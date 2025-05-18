import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/pages/main_wallet_page.dart';

import '../wallet/wallet.dart';

class EnterPasswordPage extends StatefulWidget {
  final Wallet theWallet;

  const EnterPasswordPage({super.key, required this.theWallet});

  static const routeName = '/enterPasswordPage';

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .enterPasswordOf(widget.theWallet.name),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.password,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.scrim,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              cursorColor:
                                  Theme.of(context).colorScheme.tertiary,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                                hintText: AppLocalizations.of(context)!
                                    .enterThePassword,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 48,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                final mnemonic = await widget.theWallet
                                    .getMnemonic(password);
                                if (mnemonic == null || mnemonic == "") {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .wrongPassword)));
                                } else {
                                  if (!context.mounted) return;
                                  context.go(MainWalletPage.routeName,
                                      extra: widget.theWallet);
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
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
            )),
      ),
    );
  }
}
