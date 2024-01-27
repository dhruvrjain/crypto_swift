import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletConnectService {
  final String dappUrl; // URL of the DApp
  final String walletConnectBridge; // WalletConnect bridge URL

  WalletConnectService({required this.dappUrl, required this.walletConnectBridge});

  Future<Map<String, dynamic>> sendWalletConnectRequest(
      String method, Map<String, dynamic> params) async {
    final requestId = DateTime.now().millisecondsSinceEpoch;
    final url = '$walletConnectBridge?sessionId=$requestId';

    final requestPayload = {
      'id': requestId,
      'jsonrpc': '2.0',
      'method': method,
      'params': params,
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Handle the WalletConnect response here
      return jsonResponse;
    } else {
      throw Exception('Failed to send WalletConnect request');
    }
  }

  Future<void> connectWallet() async {
    final requestParams = {
      'from': '0xCfF79210736967E7C6103CE7e41E24db444Bf638',
      'to':'0xfD5700453f4f8a000d1a906E55B59671E20D8C72',
      'data':'0x',
      'value':'0x01'
    };

    try {
      final response =
          await sendWalletConnectRequest('eth_sendTransaction', requestParams);

      // Handle the wc_sessionRequest response here
      print('WalletConnect Response: $response');
      
      // Extract necessary information from the response and perform further actions
      final bool approved = response['result']['approved'];
      final int chainId = response['result']['chainId'];
      final List<String> accounts = List<String>.from(response['result']['accounts']);

      if (approved) {
        // The user has approved the connection, you can proceed with further actions
        print('Connection approved. Chain ID: $chainId, Accounts: $accounts');
      } else {
        // Handle rejection or any other logic
        print('Connection rejected.');
      }
    } catch (e) {
      print('Error connecting to WalletConnect: $e');
    }
  }
}
