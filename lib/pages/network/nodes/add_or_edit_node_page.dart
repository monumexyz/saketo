import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:saketo/main.dart';
import 'package:saketo/nodes/node.dart';
import 'package:saketo/pages/network/nodes/manage_nodes_page.dart';
import 'package:uuid/v4.dart';

class AddOrEditNodePage extends StatefulWidget {
  final String nodeId; // Internal ID of the node
  final bool isEdit; // True if the page is for editing an existing node, false if it is for adding a new node

  const AddOrEditNodePage({super.key, required this.nodeId, required this.isEdit});

  static const routeName = '/addOrEditNodePage';

  @override
  State<AddOrEditNodePage> createState() => _EditNodesPageState();
}

class _EditNodesPageState extends State<AddOrEditNodePage> {
  String _nodeName = '';
  String _nodeUrl = '';
  int _nodePort = 0;
  bool _isSecure = false;
  late Node _node;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _node = objectbox.store.box<Node>().getAll().firstWhere((element) => element.internalId == widget.nodeId);
      _nodeName = _node.name;
      _nodeUrl = _node.url;
      _nodePort = _node.port;
      _isSecure = _node.isSecure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
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
                          context.pop();
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        widget.isEdit
                            ? AppLocalizations.of(context)!.editNode
                            : AppLocalizations.of(context)!.addNode,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  if (widget.isEdit)
                    GestureDetector(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            'app_assets/trash.svg',
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.surface,
                                BlendMode.srcIn),
                          ),
                        ),
                        onTap: () {
                          if (objectbox.store.box<Node>().getAll().length > 1) {
                            final node = objectbox.store.box<Node>().getAll().firstWhere((element) => element.internalId == widget.nodeId);
                            objectbox.store.box<Node>().remove(node.id!);
                            final firstNode = objectbox.store.box<Node>().getAll().first;
                            firstNode.isActive = true;
                            objectbox.store.box<Node>().put(firstNode);
                            context.pop(true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text(AppLocalizations.of(context)!.needOneNode),
                              ),
                            );
                          }
                        }
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1,
                        ),
                        color: Theme.of(context).colorScheme.secondary
                    ),
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
                                AppLocalizations.of(context)!.nodeName,
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
                                child: TextFormField(
                                  maxLines: 1,
                                  initialValue: widget.isEdit ? _node.name : '',
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                  onChanged: (value) {
                                    setState(() {
                                      _nodeName = value;
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
                                        .nodeNameHint,
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
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          height: 1,
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
                                AppLocalizations.of(context)!.nodeUrl,
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
                                child: TextFormField(
                                  initialValue: widget.isEdit ? _node.url : '',
                                  maxLines: 1,
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                  onChanged: (value) {
                                    setState(() {
                                      _nodeUrl = value;
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
                                        .nodeUrlHint,
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
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          height: 1,
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
                                AppLocalizations.of(context)!.nodePort,
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
                                child: TextFormField(
                                  buildCounter: (context, {required currentLength, maxLength, required isFocused}) => null, // Hide the character counter
                                  initialValue: widget.isEdit ? _node.port.toString() : '',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 5,
                                  maxLines: 1,
                                  onTapOutside: (event) =>
                                      FocusScope.of(context).unfocus(),
                                  onChanged: (value) {
                                    setState(() {
                                      _nodePort = int.parse(value);
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
                                        .nodePortHint,
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
                        Divider(
                          color: Theme.of(context).colorScheme.surface,
                          height: 1,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.useHttps,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              Switch(
                                value: _isSecure,
                                onChanged: (value) {
                                  setState(() {
                                    _isSecure = value;
                                  });
                                },
                                activeColor: Theme.of(context).colorScheme.tertiary,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
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
                  const SizedBox(
                    height: 48,
                    width: 48,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (widget.isEdit) {
                              _node.name = _nodeName;
                              _node.url = _nodeUrl;
                              _node.port = _nodePort;
                              _node.isSecure = _isSecure;
                              objectbox.store.box<Node>().put(_node);
                            } else {
                              final node = Node(const UuidV4().generate(), _nodeName, _nodeUrl, _nodePort, _isSecure, false, false);
                              objectbox.store.box<Node>().put(node);
                            }
                            context.pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              foregroundColor:
                              Theme.of(context).colorScheme.tertiary,
                              backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(widget.isEdit ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.add,
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
        ),
      ),
    ));
  }
}

