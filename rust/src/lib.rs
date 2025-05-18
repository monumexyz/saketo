use aes_gcm::aead::Aead;
use aes_gcm::{AeadCore, Aes256Gcm, Key, KeyInit, Nonce};
use argon2::Argon2;
use base64::Engine;
use curve25519_dalek::Scalar;
use polyseed::{self};
use monero_seed;
use rand::RngCore;
use zeroize::Zeroizing;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use rand::rngs::OsRng;
use monero_serai::primitives::keccak256;
use monero_wallet::address::{AddressType, Network};

// --------------------------------
// TYPES AND OTHERS
// --------------------------------

#[repr(C)]
pub struct ResultWithMessage {
    success: bool,
    message: *const c_char,
}

impl ResultWithMessage {
    fn new(success: bool, message: &str) -> Self {
        let c_message = CString::new(message).unwrap();
        ResultWithMessage {
            success,
            message: c_message.into_raw(),
        }
    }
}

fn c_str_to_string(c_str: *const c_char) -> String {
    let c_str = unsafe {
        assert!(!c_str.is_null());
        CStr::from_ptr(c_str)
    };
    c_str.to_str().unwrap_or("").to_string()
}

#[no_mangle]
pub extern "C" fn get_block_height_from_unix_time(unix_time: i64) -> i64 {
    let time_diff = unix_time.saturating_sub(1635724948); // This number corresponds to Polyseed's earliest possible birthday
    let early_day_seconds = time_diff / 730; // A day earlier for every two years for safety
    let block_height = time_diff.saturating_sub(early_day_seconds) / 120;
    (2483380 + block_height).try_into().unwrap() // This number corresponds to Monero's block height at Polyseed's earliest possible birthday
}

// --------------------------------
// ENCRYPTION
// --------------------------------

#[no_mangle]
pub extern "C" fn encrypt_data(password: *const c_char, data: *const c_char) -> *mut c_char {
    let password = unsafe { CStr::from_ptr(password) }.to_str().unwrap_or("").to_string();
    let data = unsafe { CStr::from_ptr(data) }.to_str().unwrap_or("").to_string();
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);
    let mut key = [0u8; 32];
    Argon2::default().hash_password_into(password.as_bytes(), &salt, &mut key).unwrap();
    let key = Key::<Aes256Gcm>::from_slice(&key);
    let cipher = Aes256Gcm::new(key);
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let ciphertext = match cipher.encrypt(&nonce, data.as_bytes()) {
        Ok(ct) => ct,
        Err(_) => return CString::new("ENCRYPTION_FAILED").unwrap().into_raw(),
    };
    // Combine: ciphertext + nonce + salt
    let mut combined = Vec::new();
    combined.extend_from_slice(&ciphertext);
    combined.extend_from_slice(&nonce);
    combined.extend_from_slice(&salt);
    let encoded = base64::engine::general_purpose::STANDARD.encode(&combined);
    CString::new(encoded).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn decrypt_data(password: *const c_char, encrypted_data: *const c_char) -> *mut c_char {
    let password = unsafe { CStr::from_ptr(password) }.to_str().unwrap_or("").to_string();
    let encrypted_data = unsafe { CStr::from_ptr(encrypted_data) }.to_str().unwrap_or("").to_string();

    let encrypted_data = match base64::engine::general_purpose::STANDARD.decode(encrypted_data) {
        Ok(data) => data,
        Err(_) => return CString::new("INVALID_BASE64").unwrap().into_raw(),
    };

    if encrypted_data.len() < 28 {
        return CString::new("INVALID_DATA").unwrap().into_raw();
    }

    let ciphertext_len = encrypted_data.len() - 28;
    let (ciphertext, rest) = encrypted_data.split_at(ciphertext_len);
    let (nonce, salt) = rest.split_at(12);
    let mut key = [0u8; 32];
    Argon2::default().hash_password_into(password.as_bytes(), salt, &mut key).unwrap();
    let key = Key::<Aes256Gcm>::from_slice(&key);
    let cipher = Aes256Gcm::new(key);
    let nonce = Nonce::from_slice(nonce);
    let plaintext = match cipher.decrypt(nonce, ciphertext) {
        Ok(data) => data,
        Err(_) => {
            return CString::new("DECRYPTION_FAILED").unwrap().into_raw();
        }
    };
    CString::new(plaintext).unwrap().into_raw()
}

// --------------------------------
// POLYSEED
// --------------------------------

#[no_mangle]
extern "C" fn generate_polyseed_mnemonic() -> *mut c_char {
    let seed = polyseed::Polyseed::new(&mut OsRng, polyseed::Language::English);
    let c_string = CString::new(seed.to_string().to_string()).unwrap();
    c_string.into_raw()
}

#[no_mangle]
extern "C" fn is_valid_polyseed_mnemonic(mnemonic: *const c_char, language_code: *const c_char) -> ResultWithMessage {
    let language = match &c_str_to_string(language_code)[..] {
        "en" => polyseed::Language::English,
        "es" => polyseed::Language::Spanish,
        "fr" => polyseed::Language::French,
        "it" => polyseed::Language::Italian,
        "ja" => polyseed::Language::Japanese,
        "ko" => polyseed::Language::Korean,
        "cs" => polyseed::Language::Czech,
        "pt" => polyseed::Language::Portuguese,
        "zh-CN" => polyseed::Language::ChineseSimplified,
        "zh-TW" => polyseed::Language::ChineseTraditional,
        _ => polyseed::Language::English,
    };
    let seed = polyseed::Polyseed::from_string(language, zeroize::Zeroizing::new(c_str_to_string(mnemonic)));
    let message = if seed.is_ok() {
        ""
    } else {
        match seed.clone().err().unwrap() {
            // TODO: Make this error messages local.
            polyseed::PolyseedError::InvalidSeed => "Invalid seed. Please check your mnemonic.",
            polyseed::PolyseedError::InvalidEntropy => "Invalid entropy. Please check your mnemonic.",
            polyseed::PolyseedError::InvalidChecksum => "Invalid checksum. Please check your mnemonic.",
            polyseed::PolyseedError::UnsupportedFeatures => "Unsupported features. Please check your mnemonic.",
        }
    };
    ResultWithMessage::new(seed.is_ok(), message)
}

#[no_mangle]
pub extern "C" fn get_primary_address_polyseed(mnemonic: *const c_char) -> *mut c_char {
    let mnemonic = unsafe { CStr::from_ptr(mnemonic) }.to_str().unwrap_or("").to_string();
    let seed = polyseed::Polyseed::from_string(polyseed::Language::English, Zeroizing::new(mnemonic)).unwrap();
    let priv_spend = Scalar::from_bytes_mod_order(*seed.key()).to_bytes();
    let priv_view = keccak256(priv_spend);
    let pub_spend = Scalar::from_bytes_mod_order(priv_spend) * curve25519_dalek::constants::ED25519_BASEPOINT_POINT;
    let pub_view = Scalar::from_bytes_mod_order(priv_view) * curve25519_dalek::constants::ED25519_BASEPOINT_POINT;
    let address = monero_wallet::address::MoneroAddress::new(Network::Mainnet, AddressType::Legacy, pub_spend, pub_view);
    CString::new(address.to_string()).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn get_block_height_polyseed(mnemonic: *const c_char) -> i64 {
    let mnemonic = unsafe { CStr::from_ptr(mnemonic) }.to_str().unwrap_or("").to_string();
    let seed = polyseed::Polyseed::from_string(polyseed::Language::English, Zeroizing::new(mnemonic)).unwrap();
    get_block_height_from_unix_time(seed.birthday().try_into().unwrap())
}

// --------------------------------
// LEGACY
// --------------------------------

#[no_mangle]
extern "C" fn generate_legacy_mnemonic() -> *mut c_char {
    let seed = monero_seed::Seed::new(&mut rand::rngs::OsRng, monero_seed::Language::English);
    let c_string = CString::new(seed.to_string().to_string()).unwrap();
    c_string.into_raw()
}

#[no_mangle]
extern "C" fn is_valid_legacy_mnemonic(mnemonic: *const c_char, language_code: *const c_char) -> ResultWithMessage {
    let language = match &c_str_to_string(language_code)[..] {
        "zh" => monero_seed::Language::Chinese,
        "en" => monero_seed::Language::English,
        "nl" => monero_seed::Language::Dutch,
        "fr" => monero_seed::Language::French,
        "es" => monero_seed::Language::Spanish,
        "de" => monero_seed::Language::German,
        "it" => monero_seed::Language::Italian,
        "pt" => monero_seed::Language::Portuguese,
        "jp" => monero_seed::Language::Japanese,
        "ru" => monero_seed::Language::Russian,
        "eo" => monero_seed::Language::Esperanto,
        "lj" => monero_seed::Language::Lojban,
        "en_deprecated" => monero_seed::Language::DeprecatedEnglish,
        _ => monero_seed::Language::English,
    };
    let seed = monero_seed::Seed::from_string(language, zeroize::Zeroizing::new(c_str_to_string(mnemonic)));
    let message = if seed.is_ok() {
        ""
    } else {
        match seed.clone().err().unwrap() {
            monero_seed::SeedError::InvalidSeed => "Invalid seed. Please check your mnemonic.",
            monero_seed::SeedError::InvalidChecksum => "Invalid checksum. Please check your 25th word.",
            monero_seed::SeedError::DeprecatedEnglishWithChecksum => "Deprecated English language option included a checksum. Please check your mnemonic.",
        }
    };
    ResultWithMessage::new(seed.is_ok(), message) 
}

#[no_mangle]
pub extern "C" fn get_primary_address_monero_seed(mnemonic: *const c_char) -> *mut c_char {
    let mnemonic = unsafe { CStr::from_ptr(mnemonic) }.to_str().unwrap_or("").to_string();
    let seed = monero_seed::Seed::from_string(monero_seed::Language::English, Zeroizing::new(mnemonic)).unwrap();
    let priv_spend = Scalar::from_bytes_mod_order(*seed.entropy()).to_bytes();
    let priv_view = keccak256(priv_spend);
    let pub_spend = Scalar::from_bytes_mod_order(priv_spend) * curve25519_dalek::constants::ED25519_BASEPOINT_POINT;
    let pub_view = Scalar::from_bytes_mod_order(priv_view) * curve25519_dalek::constants::ED25519_BASEPOINT_POINT;
    let address = monero_wallet::address::MoneroAddress::new(Network::Mainnet, AddressType::Legacy, pub_spend, pub_view);
    CString::new(address.to_string()).unwrap().into_raw()
}

// --------------------------------
// FREE
// --------------------------------

#[no_mangle]
extern "C" fn free_c_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe {
            let _ = CString::from_raw(s);
        }
    }
}