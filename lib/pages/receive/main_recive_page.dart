import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../wallet/wallet.dart';
import '../../wallet/wallet_modes/wallet_mode_abstract.dart';

class MainReceivePage extends StatelessWidget {
  final Wallet theWallet;

  const MainReceivePage({super.key, required this.theWallet});

  static const routeName = '/mainReceivePage';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: SvgPicture.asset(
                        'app_assets/arrow_left.svg',
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.surface,
                            BlendMode.srcIn),
                      ),
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.receive,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.scrim,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                WalletMode.fromName(theWallet.modeName).icon,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn),
                                height: 32,
                                width: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    theWallet.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "XMR",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.surface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' ',
                                        ),
                                        TextSpan(
                                          text: "0.00000000",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                          AppLocalizations.of(context)!.mainWalletAddress,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.scrim,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(theWallet.primaryAddress, style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: 14,
                                  ),),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(text: theWallet.primaryAddress));
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(AppLocalizations.of(context)!.addressCopied),
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    minimumSize: const Size(48, 48),
                                    maximumSize: const Size(48, 48),
                                  ),
                                  child: SvgPicture.asset(
                                    'app_assets/copy.svg',
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.tertiary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
