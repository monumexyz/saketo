import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/pages/onboarding/create_password_page.dart';
import 'package:saketo/wallet/mnemonics/polyseed/polyseed_mnemonic_type.dart';
import 'package:saketo/wallet/wallet_modes/basic/basic_mode.dart';

import '../../wallet/mnemonics/mnemonic_type.dart';
import '../../wallet/wallet_modes/wallet_mode_abstract.dart';

class PreviewConfigurationPage extends StatefulWidget {
  final Map<String, Object> extra;

  const PreviewConfigurationPage({super.key, required this.extra});

  static const routeName = '/previewConfigurationPage';

  @override
  State<PreviewConfigurationPage> createState() =>
      _PreviewConfigurationPageState();
}

class _PreviewConfigurationPageState extends State<PreviewConfigurationPage> {
  String _walletNameString = 'My Main Wallet';
  int _birthdayHeight = 0;
  MnemonicType? _chosenMnemonicType;

  @override
  Widget build(BuildContext context) {
    WalletMode walletMode = widget.extra['walletMode'] as WalletMode;
    if (walletMode is BasicMode && (widget.extra['isCreateWallet'] as bool)) {
      // Polyseed is chosen automatically for basic mode wallet creation
      _chosenMnemonicType = MnemonicType.polyseed();
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderRadius:
                                            BorderRadius.circular(32)))),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius:
                                            BorderRadius.circular(32)))),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius:
                                            BorderRadius.circular(32)))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        AppLocalizations.of(context)!.preview,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                                    (widget.extra['walletMode'] as WalletMode)
                                        .icon,
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
                                    _walletNameString == ''
                                        ? AppLocalizations.of(context)!
                                            .walletNameHint
                                        : _walletNameString,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.configuration,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
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
                            AppLocalizations.of(context)!.walletName,
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
                                  _walletNameString = value;
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
                                    .walletNameHint,
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
                    !(walletMode is BasicMode &&
                        (widget.extra['isCreateWallet'] as bool))
                        ? const SizedBox(
                      height: 16,
                    ) : const SizedBox(),
                    !(walletMode is BasicMode &&
                            (widget.extra['isCreateWallet'] as bool))
                        ? Container(
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
                                  AppLocalizations.of(context)!.mnemonicType,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.scrim,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownMenu(
                                      menuStyle: MenuStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .scrim),
                                      ),
                                        onSelected: (mnemonic) {
                                          setState(() {
                                            _chosenMnemonicType = mnemonic!;
                                          });
                                        },
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                        ),
                                        trailingIcon: SvgPicture.asset(
                                          'app_assets/chevron_down.svg',
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              BlendMode.srcIn),
                                        ),
                                        selectedTrailingIcon: SvgPicture.asset(
                                          'app_assets/chevron_up.svg',
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              BlendMode.srcIn),
                                        ),
                                        width: double.infinity,
                                        hintText: AppLocalizations.of(context)!
                                            .selectMnemonicType,
                                        dropdownMenuEntries: <DropdownMenuEntry<
                                            MnemonicType>>[
                                          DropdownMenuEntry(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .scrim),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                            ),
                                              value: MnemonicType.polyseed(),
                                              label:
                                                  '${MnemonicType.polyseed().name} (${MnemonicType.polyseed().wordCount} ${AppLocalizations.of(context)!.words})'),
                                          DropdownMenuEntry(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .scrim),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                            ),
                                              value: MnemonicType.legacy(),
                                              label:
                                                  '${MnemonicType.legacy().name} (${MnemonicType.legacy().wordCount} ${AppLocalizations.of(context)!.words})'),
                                          // DropdownMenuEntry(value: MnemonicType.mymonero(), label: '${MnemonicType.mymonero().name} (${MnemonicType.mymonero().wordCount} ${AppLocalizations.of(context)!.words})'),
                                          // TODO: MyMonero to be added when it's ready for use in monero-wallet-util
                                        ])),
                              ],
                            ))
                        : const SizedBox(),
                    const SizedBox(
                      height: 16,
                    ),
                    _chosenMnemonicType is! PolyseedMnemonicType && !(widget.extra['isCreateWallet'] as bool) ? Container(
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
                            AppLocalizations.of(context)!.blockHeight,
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8)
                              ],
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                              onChanged: (value) {
                                setState(() {
                                  _birthdayHeight = int.parse(value);
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
                                    .blockHeightHint,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ) : const SizedBox(),
                  ],
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
                              onPressed: () {
                                if (_chosenMnemonicType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .chooseAMnemonicType)));
                                } else {
                                  widget.extra.addAll({
                                    'walletName': _walletNameString,
                                    'mnemonicType': _chosenMnemonicType!,
                                    'isPINConfirmation': false,
                                    'birthdayHeight': _birthdayHeight
                                  });
                                  context.push(CreatePasswordPage.routeName,
                                      extra: widget.extra);
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
