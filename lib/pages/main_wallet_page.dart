import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saketo/main.dart';
import 'package:saketo/nodes/node.dart';
import 'package:saketo/pages/receive/main_recive_page.dart';
import 'package:saketo/pages/settings/main_settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saketo/wallet/chain/data_types.dart';

import '../services/sync_service.dart';
import '../wallet/wallet.dart';
import 'network/main_network_page.dart';

class MainWalletPage extends StatefulWidget {
  final MainWalletPageArgs args;

  const MainWalletPage({super.key, required this.args});

  static const routeName = '/mainWalletPage';

  @override
  State<MainWalletPage> createState() => _MainWalletPageState();
}

class MainWalletPageArgs {
  final Wallet theWallet;
  final String password;

  MainWalletPageArgs({required this.theWallet, required this.password});
}

class _MainWalletPageState extends State<MainWalletPage> with SingleTickerProviderStateMixin {
  late SyncService syncService;
  late final AnimationController _syncTextController;

  @override
  void initState() {
    super.initState();
    syncService = Provider.of<SyncService>(context, listen: false);

    _syncTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _syncTextController.dispose();
    super.dispose();
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
                                extra: widget.args.theWallet);
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
                                extra: widget.args.theWallet);
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
                            widget.args.theWallet.mode.icon,
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
                            widget.args.theWallet.name,
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
                              Selector<SyncService, ServiceStatus>(
                                selector: (_, service) => service.syncStatus,
                                builder: (context, status, child) {
                                  return Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: status == ServiceStatus.error
                                          ? const Color(0xFFC14242)
                                          : status == ServiceStatus.syncing
                                          ? const Color(0xFFD69E5F)
                                          : status == ServiceStatus.synced
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
                              Selector<SyncService, ServiceStatus>(
                                selector: (_, service) => service.syncStatus,
                                shouldRebuild: (previous, next) => next == ServiceStatus.error || previous != next,
                                builder: (context, status, child) {
                                  late String syncStatusText;

                                  switch (status) {
                                    case ServiceStatus.syncing:
                                      syncStatusText = AppLocalizations.of(context)!.syncing;
                                      break;
                                    case ServiceStatus.synced:
                                      syncStatusText = AppLocalizations.of(context)!.synced;
                                      break;
                                    case ServiceStatus.error:
                                      final errorMessage = context.read<SyncService>().message;
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              duration: const Duration(seconds: 5),
                                            content: Text(AppLocalizations.of(context)!.cantSyncExplanation(errorMessage)),
                                          ),
                                        );
                                      });
                                      syncStatusText = AppLocalizations.of(context)!.cantSync;
                                      break;
                                    case ServiceStatus.notSyncing:
                                      syncStatusText = AppLocalizations.of(context)!.notSyncing;
                                      break;
                                  }

                                  if (status == ServiceStatus.syncing) {
                                    return AnimatedBuilder(
                                      animation: _syncTextController,
                                      builder: (_, __) {
                                        final dots = (_syncTextController.value * 4).floor() % 4;
                                        return Text(
                                          AppLocalizations.of(context)!.syncing + '.' * dots,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  return Text(
                                    syncStatusText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          Selector<SyncService, int>(
                            selector: (_, service) => service.syncHeight,
                            builder: (context, syncHeight, child) {
                              return Text(
                                  syncHeight == 0
                                      ? widget.args.theWallet.lastSyncedHeight.toString()
                                      : syncHeight.toString(),
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
                    Selector<SyncService, ServiceStatus>(
                      selector: (_, service) => service.syncStatus,
                      builder: (context, status, child) {
                        late final String buttonIcon;
                        switch (status) {
                          case ServiceStatus.synced:
                          case ServiceStatus.syncing:
                            buttonIcon = 'app_assets/pause.svg';
                            break;
                          case ServiceStatus.error:
                            buttonIcon = 'app_assets/refresh_cw.svg';
                            break;
                          case ServiceStatus.notSyncing:
                            buttonIcon = 'app_assets/play.svg';
                            break;
                        }

                        return ElevatedButton(
                          onPressed: () async {
                            final service = context.read<SyncService>();

                            switch (status) {
                              case ServiceStatus.synced:
                              case ServiceStatus.syncing:
                                service.stopSyncing();
                                break;
                              case ServiceStatus.error:
                              case ServiceStatus.notSyncing:
                                final wallet = objectbox.store.box<Wallet>().getAll()[0];
                                final mnemonic = await widget.args.theWallet.getMnemonic(widget.args.password);

                                if (mnemonic != null) {
                                  service.startSyncing(wallet, Node.activeNode(), mnemonic);
                                }
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Transactions",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Selector<SyncService, List<Transaction>>(
                  selector: (_, service) => service.transactions,
                  builder: (context, transactions, child) {
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];

                        final totalInputs = tx.inputs.fold(0, (sum, input) => sum + input.amount);
                        final totalOutputs = tx.outputs.fold(0, (sum, output) => sum + output.amount);

                        final bool isIncoming = tx.direction == TxDirection.incoming;

                        double amount;
                        if (isIncoming) {
                          amount = totalOutputs / 1e12;
                        } else {
                          amount = (totalInputs - totalOutputs) / 1e12;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isIncoming ? Icons.south_west : Icons.north_east,
                                color: isIncoming ? Colors.green : Colors.orange,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  DateFormat('dd MMM yy').format(tx.timestamp),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "${isIncoming ? '+' : '-'} ${amount.toStringAsFixed(4)} XMR",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
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
                                extra: widget.args.theWallet);
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
