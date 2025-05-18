import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saketo/pages/network/nodes/manage_nodes_page.dart';

import '../../main.dart';
import '../../nodes/node.dart';
import '../../wallet/wallet.dart';

class MainNetworkPage extends StatefulWidget {
  final Wallet theWallet;

  const MainNetworkPage({super.key, required this.theWallet});

  static const routeName = '/mainNetworkPage';

  @override
  State<MainNetworkPage> createState() => _MainNetworkPageState();
}

class _MainNetworkPageState extends State<MainNetworkPage> {
  Node _chosenNode = Node.activeNode();

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
                      AppLocalizations.of(context)!.network,
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.activeNode,
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
                                child: DropdownMenu<Node>(
                                    initialSelection: Node.activeNode(),
                                    label: Container(
                                        color:
                                            Theme.of(context).colorScheme.scrim,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _chosenNode.name,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              _chosenNode.url,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                            ),
                                          ],
                                        )),
                                    menuStyle: MenuStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Theme.of(context).colorScheme.scrim),
                                    ),
                                    onSelected: (node) {
                                      if (_chosenNode.internalId != node!.internalId) {
                                        final activeNode = objectbox.store
                                            .box<Node>()
                                            .get(_chosenNode.id!);
                                        activeNode!.isActive = false;
                                        objectbox.store.box<Node>().put(activeNode);
                                        node.isActive = true;
                                        objectbox.store.box<Node>().put(node);
                                        setState(() {
                                          _chosenNode = node;
                                        });
                                      } else {
                                        setState(() {
                                          _chosenNode = node;
                                        });
                                      }
                                    },
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    inputDecorationTheme: InputDecorationTheme(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(12),
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
                                          Theme.of(context).colorScheme.surface,
                                          BlendMode.srcIn),
                                    ),
                                    selectedTrailingIcon: SvgPicture.asset(
                                      'app_assets/chevron_up.svg',
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).colorScheme.surface,
                                          BlendMode.srcIn),
                                    ),
                                    width: double.infinity,
                                    dropdownMenuEntries: <DropdownMenuEntry<
                                        Node>>[
                                      for (final node in objectbox.store
                                          .box<Node>()
                                          .getAll())
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
                                            value: node,
                                            label: node.name)
                                    ])),
                            const SizedBox(
                              height: 8,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  context.push(ManageNodesPage.routeName).then((value) {
                                    if (!mounted) return;
                                    context.pushReplacement(MainNetworkPage.routeName, extra: widget.theWallet);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .scrim,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: Theme.of(context).colorScheme.surface,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.manageNodes,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),),
                                )),
                          ],
                        )),
                  ],
                ),
              )
            ],
          )),
    ));
  }
}
