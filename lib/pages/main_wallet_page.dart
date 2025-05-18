import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saketo/nodes/node.dart';
import 'package:saketo/pages/receive/main_recive_page.dart';
import 'package:saketo/pages/settings/main_settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/sync_service.dart';
import '../wallet/wallet.dart';
import '../wallet/wallet_modes/wallet_mode_abstract.dart';
import 'network/main_network_page.dart';

class MainWalletPage extends StatefulWidget {
  final Wallet theWallet;

  const MainWalletPage({super.key, required this.theWallet});

  static const routeName = '/mainWalletPage';

  @override
  State<MainWalletPage> createState() => _MainWalletPageState();
}

class _MainWalletPageState extends State<MainWalletPage> {
  late SyncService syncService;

  @override
  void initState() {
    super.initState();
    syncService = Provider.of<SyncService>(context, listen: false);
  }

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
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'app_assets/saketo_logo_text_only.svg',
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.tertiary,
                          BlendMode.srcIn),
                      height: 24,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push(MainNetworkPage.routeName,
                                extra: widget.theWallet);
                          },
                          child: SvgPicture.asset('app_assets/bar_chart.svg',
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.surface,
                                  BlendMode.srcIn),
                              height: 24),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            context.push(MainSettingsPage.routeName,
                                extra: widget.theWallet);
                          },
                          child: SvgPicture.asset('app_assets/settings.svg',
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.surface,
                                  BlendMode.srcIn),
                              height: 24),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                            WalletMode.fromName(widget.theWallet.modeName).icon,
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
                            widget.theWallet.name,
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
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Consumer<SyncService>(
                                builder: (context, syncService, child) {
                                  return Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: syncService.syncStatus == 3
                                          ? const Color(0xFFC14242)
                                          : syncService.syncStatus == 1
                                          ? const Color(0xFFD69E5F)
                                          : syncService.syncStatus == 2
                                          ? const Color(0xFF468053)
                                          : const Color(0xFFB9B9B9),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Consumer<SyncService>(
                                builder: (context, syncService, child) {
                                  late String syncStatusText;
                                  switch (syncService.syncStatus) {
                                    case 1:
                                      syncStatusText = AppLocalizations.of(context)!
                                          .syncing;
                                      break;
                                    case 2:
                                      syncStatusText = AppLocalizations.of(context)!
                                          .synced;
                                      break;
                                    case 3:
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              duration: const Duration(seconds: 5),
                                                content: Text(
                                                    AppLocalizations.of(context)!.cantSyncExplanation(syncService.message))));
                                      });
                                      syncStatusText = AppLocalizations.of(context)!
                                          .cantSync;
                                    case 0:
                                    default:
                                      syncStatusText = AppLocalizations.of(context)!
                                          .notSyncing;
                                      break;
                                  }
                                  return Text(syncStatusText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                      ));
                                },
                              )
                            ],
                          ),
                          Consumer<SyncService>(
                            builder: (context, syncService, child) {
                              return Text(
                                  "${syncService.syncHeight}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.surface,
                                  ));
                            },
                          )
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 6,
                    ),
                    Consumer<SyncService>(
                      builder: (context, syncService, child) {
                        late final String buttonIcon;
                        switch (syncService.syncStatus) {
                          case 1:
                            buttonIcon = 'app_assets/pause.svg';
                            break;
                          case 2:
                            buttonIcon = 'app_assets/pause.svg';
                            break;
                          case 3:
                            buttonIcon = 'app_assets/refresh_cw.svg';
                            break;
                          case 0:
                          default:
                            buttonIcon = 'app_assets/play.svg';
                            break;
                        }
                        return ElevatedButton(
                          onPressed: () {
                            switch (syncService.syncStatus) {
                              case 1:
                                syncService.stopSyncing();
                                break;
                              case 2:
                                syncService.stopSyncing();
                                break;
                              case 3:
                                syncService.startSyncing(widget.theWallet, Node.activeNode());
                                break;
                              case 0:
                              default:
                                syncService.startSyncing(widget.theWallet, Node.activeNode());
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: const Size(48, 48),
                            maximumSize: const Size(48, 48),
                          ),
                          child: SvgPicture.asset(
                            buttonIcon,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.tertiary,
                                BlendMode.srcIn),
                            height: 24,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
              )),
              const SizedBox(height: 12),
              SizedBox(
                  width: double.infinity,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary, // Background color
                            padding: const EdgeInsets.all(
                                12), // Padding inside button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Border radius
                            ),
                          ),
                          onPressed: () {
                            context.push(MainReceivePage.routeName,
                                extra: widget.theWallet);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.scrim,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: SvgPicture.asset(
                                  'app_assets/arrow_down_circle.svg',
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.tertiary,
                                      BlendMode.srcIn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.receive,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        )),
                        const SizedBox(width: 6),
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondary, // Background color
                            padding: const EdgeInsets.all(
                                12), // Padding inside button
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Border radius
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.scrim,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: SvgPicture.asset(
                                  'app_assets/send.svg',
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.tertiary,
                                      BlendMode.srcIn),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(AppLocalizations.of(context)!.send,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ))
            ],
          )),
    ));
  }
}
