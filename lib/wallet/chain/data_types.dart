import 'dart:convert';
import 'dart:typed_data';

enum TxDirection { incoming, outgoing, internal }

class Transaction {
  final int height;
  final Uint8List hash;
  final DateTime timestamp;
  final TxDirection direction;

  final List<TxIn> inputs;
  final List<TxOut> outputs;

  Transaction({
    required this.height,
    required this.hash,
    required this.timestamp,
    required this.direction,
    required this.inputs,
    required this.outputs,
  });

  static String encodeInputs(List<Transaction> transactions) {
    List<Map<String, dynamic>> inputList = [];
    transactions.forEach((tx) {
      tx.inputs.forEach((input) {
        inputList.add({
          'height': tx.height,
          'key_image': input.keyImage.toList(),
          'amount': input.amount,
          'hash': tx.hash.toList(),
          'timestamp': tx.timestamp.millisecondsSinceEpoch ~/ 1000,
          'previous_output': input.previousOutput.toList(),
        });
      });
    });
    return jsonEncode(inputList);
  }

  static String encodeOutputs(List<Transaction> transactions) {
    List<Map<String, dynamic>> outputList = [];
    transactions.forEach((tx) {
      tx.outputs.forEach((output) {
        outputList.add({
          'height': tx.height,
          'key_image': output.keyImage.toList(),
          'amount': output.amount,
          'hash': tx.hash.toList(),
          'timestamp': tx.timestamp.millisecondsSinceEpoch ~/ 1000,
          'index': output.index,
        });
      });
    });
    return jsonEncode(outputList);
  }

  static List<Transaction> decodeTransactions(String rawInputs, String rawOutputs) {
    final List<dynamic> decodedInputs = jsonDecode(rawInputs);
    final List<dynamic> decodedOutputs = jsonDecode(rawOutputs);

    final Map<String, Map<String, dynamic>> txMap = {};

    for (var input in decodedInputs) {
      final List<int> hashBytes = List<int>.from(input['hash']);
      final String hashKey = base64Encode(hashBytes);

      if (!txMap.containsKey(hashKey)) {
        txMap[hashKey] = {
          'height': input['height'],
          'hash': Uint8List.fromList(hashBytes),
          'timestamp': DateTime.fromMillisecondsSinceEpoch(input['timestamp'] * 1000),
          'inputs': <TxIn>[],
          'outputs': <TxOut>[],
        };
      }

      final txData = txMap[hashKey]!;
      (txData['inputs'] as List<TxIn>).add(TxIn(
        amount: input['amount'],
        keyImage: Uint8List.fromList(List<int>.from(input['key_image'])),
        previousOutput: Uint8List.fromList(List<int>.from(input['previous_output'])),
      ));
    }

    for (var output in decodedOutputs) {
      final List<int> hashBytes = List<int>.from(output['hash']);
      final String hashKey = base64Encode(hashBytes);

      if (!txMap.containsKey(hashKey)) {
        txMap[hashKey] = {
          'height': output['height'],
          'hash': Uint8List.fromList(hashBytes),
          'timestamp': DateTime.fromMillisecondsSinceEpoch(output['timestamp'] * 1000),
          'inputs': <TxIn>[],
          'outputs': <TxOut>[],
        };
      }

      final txData = txMap[hashKey]!;
      (txData['outputs'] as List<TxOut>).add(TxOut(
        amount: output['amount'],
        keyImage: Uint8List.fromList(List<int>.from(output['key_image'])),
        index: output['index'],
        isChange: (txData['inputs'] as List<TxIn>).isNotEmpty,
      ));
    }

    final List<Transaction> transactions = [];

    txMap.forEach((key, data) {
      final List<TxIn> inputs = data['inputs'];
      final List<TxOut> outputs = data['outputs'];
      TxDirection direction;

      if (inputs.isNotEmpty && outputs.isNotEmpty) {
        direction = TxDirection.internal;
      } else if (inputs.isEmpty && outputs.isNotEmpty) {
        direction = TxDirection.incoming;
      } else {
        direction = TxDirection.outgoing;
      }

      transactions.add(Transaction(
        height: data['height'],
        hash: data['hash'],
        timestamp: data['timestamp'],
        direction: direction,
        inputs: inputs,
        outputs: outputs,
      ));
    });

    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return transactions;
  }
}

class TxIn {
  final int amount;
  final Uint8List keyImage;
  final Uint8List previousOutput;

  TxIn({required this.amount, required this.keyImage, required this.previousOutput});
}

class TxOut {
  final int amount;
  final Uint8List keyImage;
  final int index;
  final bool isChange;

  TxOut({required this.amount, required this.keyImage, required this.index, required this.isChange});
}