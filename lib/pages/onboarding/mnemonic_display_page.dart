import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/main.dart';
import 'package:saketo/pages/enter_password_page.dart';
import 'package:saketo/rust_ffi/rust_ffi.dart';
import 'package:saketo/wallet/mnemonics/mnemonic_type.dart';
import 'package:saketo/wallet/mnemonics/polyseed/polyseed_mnemonic_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../wallet/wallet.dart';
import '../../wallet/wallet_modes/wallet_mode_abstract.dart';

class MnemonicDisplayPage extends StatelessWidget {
  final Map<String, Object> extra;

  const MnemonicDisplayPage({super.key, required this.extra});

  static const routeName = '/mnemonicDisplayPage';

  @override
  Widget build(BuildContext context) {
    int index = 0;
    MnemonicType chosenMnemonicType = extra['mnemonicType'] as MnemonicType;
    int wordCount = chosenMnemonicType.wordCount;
    List<String> mnemonicWords = chosenMnemonicType.generateMnemonic();;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 6,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(32)),
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(32)))),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(32)))),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(32)))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.mnemonicReview,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.writeItDown,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    AppLocalizations.of(context)!.mnemonicDisplayExplanation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = index; i < wordCount; i = i + 2)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 32,
                                          child: Text(
                                            "${i + 1}.",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                          child: Text(
                                        mnemonicWords[i],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ],
                                  ))),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            decoration: (((wordCount % 2 != 0) &&
                                        (i + 1 != wordCount)) ||
                                    (wordCount % 2 == 0))
                                ? BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(5))
                                : const BoxDecoration(),
                            child: (((wordCount % 2 != 0) &&
                                        (i + 1 != wordCount)) ||
                                    (wordCount % 2 == 0))
                                ? Row(
                                    children: [
                                      SizedBox(
                                          width: 32,
                                          child: Text(
                                            "${i + 2}.",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                          )),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                          child: Text(
                                        mnemonicWords[i + 1],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ],
                                  )
                                : null,
                          )),
                        ],
                      ),
                    ),
                ],
              ),
            )),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: SvgPicture.asset(
                        'app_assets/arrow_left.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.surface,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            late final String primaryAddress;
                            try {
                              primaryAddress = getPrimaryAddress(mnemonicWords.join(" "), chosenMnemonicType);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 5),
                                      content: Text(
                                          "${AppLocalizations.of(context)!.errorGeneratingAddress} $e")));
                              return;
                            }
                            if (primaryAddress == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                          AppLocalizations.of(context)!.errorGeneratingAddress)));
                              return;
                            }
                            int birthdayHeight = 0;
                            if ((extra['mnemonicType'] as MnemonicType) is PolyseedMnemonicType) {
                              final mnemonic = mnemonicWords.join(" ");
                              birthdayHeight = getBlockHeightPolyseed(mnemonic);
                            } else {
                              birthdayHeight = getBlockHeightFromUnixTime(DateTime.now().millisecondsSinceEpoch ~/ 1000);
                            }
                            final wallet = Wallet(
                              internalId: const Uuid().v4(),
                              name: extra['walletName'] as String,
                              modeName: (extra['walletMode'] as WalletMode).name,
                              mnemonicTypeName: chosenMnemonicType.name,
                              primaryAddress: primaryAddress,
                              birthdayHeight: birthdayHeight,
                              lastSyncedHeight: birthdayHeight,
                            );
                            objectbox.store.box<Wallet>().put(wallet);
                            final isSaved = await wallet.saveMnemonic(mnemonicWords.join(" "), extra['password'] as String);
                            if (!context.mounted) return;
                            if (!isSaved) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                          AppLocalizations.of(context)!.errorSavingMnemonic)));
                              return;
                            }
                            extra.remove('password');
                            final sharedPrefs = await SharedPreferences.getInstance();
                            sharedPrefs.setBool("is_initialized", true);
                            if (context.mounted) {
                              context.go(EnterPasswordPage.routeName, extra: wallet);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(AppLocalizations.of(context)!.next,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16)))),
                  const SizedBox(
                    width: 16,
                  ),
                  const SizedBox(
                    width: 48,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
