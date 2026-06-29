# Saketo

First mobile Monero wallet to use Rust under the hood, built upon [libsaketo](https://github.com/monumexyz/libsaketo)

This project is still Work-In-Progress! You may star the repo to learn the news about it.

## Building

Prerequisites:
- [Rust and Cargo](https://www.rust-lang.org/tools/install)
- [Flutter and Dart SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- [NDK](https://developer.android.com/ndk/guides)
- OpenSSL

Steps:
1 - Fetch libsaketo
```bash
git submodule update --init --recursive
```

2 - Build Rust code for Android
```bash
cd libsaketo/ffi && cargo ndk -t arm64-v8a -t armeabi-v7a -o ./../../android/app/src/main/jniLibs build --release
```

3 - Generate `.g.dart` files
```bash
dart run build_runner build
```

4 - Generate localization files
```bash
flutter gen-l10n
```

Then you can build or run the app in Android Studio.
