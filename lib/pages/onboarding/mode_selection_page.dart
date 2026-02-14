import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saketo/pages/onboarding/preview_configuration_page.dart';

import '../../wallet/modes/advanced_mode.dart';
import '../../wallet/modes/basic_mode.dart';
import '../../wallet/modes/paranoia_mode.dart';
import '../../wallet/modes/wallet_mode_abstract.dart';

class ModeSelectionPage extends StatefulWidget {
  final Map<String, Object> extra;

  const ModeSelectionPage({super.key, required this.extra});

  static const routeName = '/modeSelectionPage';

  @override
  State<ModeSelectionPage> createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {
  WalletMode _selectedMode = WalletMode.basic();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Container(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                        const Spacer(),
                        Text(
                          AppLocalizations.of(context)!.chooseWalletMode,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
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
                            Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMode = WalletMode.basic();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: _selectedMode is BasicMode
                                                ? Theme.of(context).colorScheme.secondary
                                                : Theme.of(context).colorScheme.scrim,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: _selectedMode is BasicMode
                                                          ? Theme.of(context)
                                                          .colorScheme
                                                          .scrim
                                                          : Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.basic().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        _selectedMode is BasicMode
                                                            ? Theme.of(context)
                                                            .colorScheme
                                                            .tertiary
                                                            : Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!.basic,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                    fontSize: 14,
                                                    fontWeight: _selectedMode is BasicMode
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .basicDescription,
                                              style: TextStyle(
                                                color:
                                                Theme.of(context).colorScheme.surface,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            SizedBox(
                                                width: double.infinity,
                                                height: 24,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: _selectedMode is BasicMode
                                                            ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                            : Theme.of(context)
                                                            .colorScheme
                                                            .scrim,
                                                        border: Border.all(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                      ),
                                                      child: Center(
                                                        child: Visibility(
                                                            visible: _selectedMode is BasicMode,
                                                            child: Container(
                                                              width: 14,
                                                              height: 14,
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .tertiary,
                                                                shape: BoxShape.circle,
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    )),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMode = WalletMode.advanced();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: _selectedMode is AdvancedMode
                                                ? Theme.of(context).colorScheme.secondary
                                                : Theme.of(context).colorScheme.scrim,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: _selectedMode is AdvancedMode
                                                          ? Theme.of(context)
                                                          .colorScheme
                                                          .scrim
                                                          : Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.advanced().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        _selectedMode is AdvancedMode
                                                            ? Theme.of(context)
                                                            .colorScheme
                                                            .tertiary
                                                            : Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!.advanced,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                    fontSize: 14,
                                                    fontWeight: _selectedMode is AdvancedMode
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .advancedDescription,
                                              style: TextStyle(
                                                color:
                                                Theme.of(context).colorScheme.surface,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            SizedBox(
                                                width: double.infinity,
                                                height: 24,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: _selectedMode is AdvancedMode
                                                            ? Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                            : Theme.of(context)
                                                            .colorScheme
                                                            .scrim,
                                                        border: Border.all(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                      ),
                                                      child: Center(
                                                        child: Visibility(
                                                            visible: _selectedMode is AdvancedMode,
                                                            child: Container(
                                                              width: 14,
                                                              height: 14,
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .tertiary,
                                                                shape: BoxShape.circle,
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle when paranoia mode is implemented
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: _selectedMode is ParanoiaMode
                                                          ? Theme.of(context)
                                                          .colorScheme
                                                          .scrim
                                                          : Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.paranoia().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        _selectedMode is ParanoiaMode
                                                            ? Theme.of(context)
                                                            .colorScheme
                                                            .tertiary
                                                            : Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: 40,
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!
                                                          .soon,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .paranoia,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary,
                                                    fontSize: 14,
                                                    fontWeight: _selectedMode is ParanoiaMode
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .paranoiaDescription,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.shadow,
                                        border: Border.all(
                                          color:
                                          Theme.of(context).colorScheme.tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Visibility(
                                            visible:
                                            _selectedMode is ParanoiaMode,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle when lightweight mode is implemented
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.lightweight().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: 40,
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!
                                                          .soon,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .lightweight,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .lightweightDescription,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.shadow,
                                        border: Border.all(
                                          color:
                                          Theme.of(context).colorScheme.tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Visibility(
                                            visible: false,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle when hardware mode is implemented
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.hardware().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: 40,
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!
                                                          .soon,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .hardware,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .hardwareDescription,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4A4A4A),
                                        border: Border.all(
                                          color:
                                          Theme.of(context).colorScheme.tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Visibility(
                                            visible: false,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle when business mode is implemented
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.business().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: 40,
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!
                                                          .soon,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .business,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .businessDescription,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4A4A4A),
                                        border: Border.all(
                                          color:
                                          Theme.of(context).colorScheme.tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Visibility(
                                            visible: false,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Handle when Multisignature mode is implemented
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.shadow,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: const EdgeInsets.all(10),
                                                  height: 40,
                                                  width: 40,
                                                  child: SvgPicture.asset(
                                                    WalletMode.multisignature().icon,
                                                    colorFilter: ColorFilter.mode(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        BlendMode.srcIn),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .shadow,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  height: 40,
                                                  width: 60,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(context)!
                                                          .soon,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .multisignature,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .multisignatureDescription,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4A4A4A),
                                        border: Border.all(
                                          color:
                                          Theme.of(context).colorScheme.tertiary,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Visibility(
                                            visible: false,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
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
                                  widget.extra.addAll({
                                    'walletMode': _selectedMode,
                                  });
                                  context.push(PreviewConfigurationPage.routeName,
                                      extra: widget.extra);
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
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
                ]))));
  }
}
