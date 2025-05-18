import 'package:objectbox/objectbox.dart';

import '../main.dart';

@Entity()
class Node {
  int? id; // ObjectBox ID

  String internalId; // UUIDv4 random ID
  String name; // User defined name
  String url; // Node's URL (ex: node1.saketo.io)
  int port; // Node's port (ex: 18081)
  bool isSecure; // HTTPS or HTTP
  bool isTor; // Tor or not
  bool isActive; // Active or not

  Node(this.internalId, this.name, this.url, this.port, this.isSecure, this.isTor, this.isActive);

  static Node activeNode() {
    return objectbox.store.box<Node>().getAll().firstWhere((element) => element.isActive, orElse: () {
      final firstNode = objectbox.store.box<Node>().getAll().first;
      firstNode.isActive = true;
      objectbox.store.box<Node>().put(firstNode);
      return firstNode;
    });
  }
}