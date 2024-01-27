import 'dart:convert';

import 'package:crypto_swift/appDrawer.dart';
import 'package:crypto_swift/model/user.dart';
import 'package:crypto_swift/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openQrScanner(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const QrScanner()));
  }

  late W3MService _w3mService;
  String currentPage = 'Metamask';
  bool? verified;
  bool? accountExists;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bankidController = TextEditingController();

  Future<void> checkAccount() async {
    final res = await http.post(Uri.parse('http://172.31.99.25:3000/isuser'),
        body: json.encode({'wallet_id': widget.user.walletAddress}),
        headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> resBody = jsonDecode(res.body);
    print("Athu ${resBody['flag']}");
    accountExists = resBody['flag'];
    setState(() {
      if (accountExists == true) {
        currentPage = 'Verify';
      } else {
        currentPage = 'Register';
      }
    });
  }

  Future<void> verify(String pin) async {
    final res = await http.post(Uri.parse('http://172.31.99.25:3000/verify'),
        body: json
            .encode({'wallet_id': widget.user.walletAddress, 'password': pin}),
        headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> resBody = jsonDecode(res.body);
    print("Pin ${resBody['flag']}");
    verified = resBody['flag'];
    setState(() {
      if (verified == true) {
        currentPage = 'Nknfdk0';
      } else {
        print('retry');
      }
    });
  }

  Future<void> register(String pin, String username,String bankid) async {
    final res = await http.post(Uri.parse('http://172.31.99.25:3000/create'),
        body: json.encode({
          'wallet_id': widget.user.walletAddress,
          'password': pin,
          'username': username,
          'bank_id' : bankid
        }),
        headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> resBody = jsonDecode(res.body);
    print("Create ${resBody['password']}");
    setState(() {
      currentPage = 'Nknfdk0';
    });
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    _w3mService = W3MService(
      projectId: '17e3639e116063d3ba08000ed456d1f8',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'w3m://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    W3MChainPresets.chains.putIfAbsent(
        '80001',
        () => W3MChainInfo(
            chainName: 'Polygon Mumbai',
            chainId: '80001',
            namespace: 'eip155:80001',
            tokenName: "MATIC",
            rpcUrl: "https://rpc-mumbai.maticvigil.com/"));
    W3MChainPresets.chains.putIfAbsent(
        '80001',
        () => W3MChainInfo(
            chainName: 'Test Token 1',
            chainId: '80001',
            namespace: 'eip155:80001',
            tokenName: "TT1",
            rpcUrl:
                "https://polygon-mumbai.g.alchemy.com/v2/1Hh1jM_H51CHnUnXDWiYwecKRkGtQhCc"));
    await _w3mService.init();
    _w3mService.web3App!.onSessionConnect.subscribe((args) {
      setState(() {
        widget.user.walletAddress = _w3mService.address;
        if (accountExists == null)
          print('null');
        else {
          if (accountExists == true) {
            currentPage = 'Verify';
          } else {
            currentPage = 'Register';
          }
        }
      });
    });
    _w3mService.web3App!.onSessionConnect.subscribe((args) {
      setState(() {
        widget.user.walletAddress = _w3mService.address;
        checkAccount();
      });
    });
    _w3mService.web3App!.onSessionDelete.subscribe((args) {
      setState(() {
        widget.user.walletAddress = null;
        currentPage = 'Metamask';
      });
    });
    // print(_w3mService.isConnected);
    print(_w3mService.address);
    // print(_w3mService.chainBalance);
    print(_w3mService.session);
    // print(_w3mService.avatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
        appBar: AppBar(title: const Text('CryptoSwift')),
        drawer: AppDrawer(user: widget.user),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (currentPage == 'Metamask')
                ? [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     openQrScanner(context);
                    //   },
                    //   child: const Text("QRCODE Scanner"),
                    // ),
                    const Text(
                        'Login to your Metamask Wallet using the button below !'),
                    const SizedBox(
                      height: 30,
                    ),
                    W3MConnectWalletButton(service: _w3mService),
                    const SizedBox(
                      height: 30,
                    ),
                    W3MNetworkSelectButton(service: _w3mService),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // sendTransaction();
                    //   },
                    //   child: const Text('Send'),
                    // ),
                  ]
                : (currentPage == 'Verify')
                    ? [
                        Text(
                          'Enter your pin for the CryptoSwift account',
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Pinput(
                          length: 4,
                          validator: (s) {
                            verify(s!);
                            return (verified == true)
                                ? null
                                : "Pin is incorrect";
                          },
                          onCompleted: (s) {
                            verify(s);
                          },
                        ),
                      ]
                    : (currentPage == 'Register')
                        ? [
                            Text(
                              'Enter your username:',
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              maxLength: 20,
                              controller: _usernameController,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text('Enter your Bank ID:'),
                            TextField(
                              maxLength: 20,
                              controller: _bankidController,
                            ),
                            SizedBox(height: 20),
                            Pinput(
                              length: 4,
                              onCompleted: (s) {
                                register(s, _usernameController.text,_bankidController.text);
                              },
                            ),
                          ]
                        : [
                            Text(
                              "OKay.... Logout below",
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentPage = 'Metamask';
                                  _w3mService.disconnect();
                                });
                              },
                              child: Text(
                                'Logout',
                              ),
                            ),
                          ],
          ),
        ),
      ),
    );
  }

  // void sendTransaction() async {
  //   if (!_w3mService.isConnected) {
  //     print('Not Connected');
  //   } else {
  //     final transactionParams = {
  //       'from': _w3mService.address, // Sender's wallet address
  //       'to':
  //           '0xfD5700453f4f8a000d1a906E55B59671E20D8C72', // Recipient's wallet address
  //       'value': '0x1', // Amount to send, in wei (adjust accordingly)
  //       'gas': '0x5208', // Gas limit (adjust accordingly)
  //     };
  //     try {
  //       final transactionSender = CustomTransactionSender;

  //       // Handle the transaction success (you can display the transaction hash or other information)
  //       print('Transaction sent successfully. Hash: ');
  //     } catch (error) {
  //       // Handle transaction failure
  //       print('Error sending transaction: $error');
  //     }
  //   }
  // }
}
