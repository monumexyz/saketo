import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/main.dart';
import 'package:saketo/pages/network/nodes/add_or_edit_node_page.dart';

import '../../../nodes/node.dart';

class ManageNodesPage extends StatefulWidget {
  const ManageNodesPage({super.key});

  static const routeName = '/manageNodesPage';

  @override
  State<ManageNodesPage> createState() => _ManageNodesPageState();
}

class _ManageNodesPageState extends State<ManageNodesPage> {

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                              context.pop(true);
                            },
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.manageNodes,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: SvgPicture.asset(
                              'app_assets/plus.svg',
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.surface,
                                  BlendMode.srcIn),
                            ),
                          ),
                          onTap: () async {
                            context.push(AddOrEditNodePage.routeName, extra: Map<String, Object>.from({
                              'nodeId': '',
                              'isEdit': false,
                            })).then((value) {
                              setState(() {});
                            });
                          }
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final node in objectbox.store.box<Node>().getAll())
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              node.name,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                Theme.of(context).colorScheme.tertiary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              node.url,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                Theme.of(context).colorScheme.surface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Container(
                                    width: 1,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                      ),
                                      onPressed: () async {
                                        final result = await context.push<bool>(AddOrEditNodePage.routeName, extra: Map<String, Object>.from({
                                          'nodeId': node.internalId,
                                          'isEdit': true,
                                        }));
                                        if (result!) {
                                          setState(() {});
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        'app_assets/edit.svg',
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context).colorScheme.tertiary,
                                            BlendMode.srcIn),
                                        width: 24,
                                      )),
                                ],
                              ),
                            )
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
