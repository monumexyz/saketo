import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:saketo/error_handling/result.dart';

import '../nodes/node.dart';

class MoneroRpc {
  static Future<Result<Map<String, dynamic>>> post(Node node, String method, Map<String, dynamic> params) async {
    try {
      final response = await http.post(Uri.parse("${node.isSecure ? "https://" : "http://"}${node.url}:${node.port}/json_rpc"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'jsonrpc': '2.0',
            'id': 0,
            'method': method,
            'params': params,
          }));
      return Result.ok(jsonDecode(response.body));
    } catch (e) {
      Logger.root.log(Level.SEVERE, 'Error when calling RPC method "$method": $e');
      return Result.error("Error when calling RPC method $method : $e");
    }
  }

  static Future<Result<int>> getBlockCount(Node node) async {
    final response = await post(node, 'get_block_count', {});
    if (response is Ok<Map<String, dynamic>>) {
      return Result.ok(response.value['result']['count']);
    } else {
      return Result.error((response as Error).errorMessage);
    }
  }
}