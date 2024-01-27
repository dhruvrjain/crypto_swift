import 'package:crypto_swift/appDrawer.dart';
import 'package:crypto_swift/model/user.dart';
import 'package:crypto_swift/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openQrScanner(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const QrScanner()));
  }

  late W3MService _w3mService;

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
    W3MChainPresets.chains.putIfAbsent('80001', () => W3MChainInfo(chainName: 'Polygon Mumbai', chainId: '80001', namespace: 'eip155:80001', tokenName: "MATIC", rpcUrl: "https://rpc-mumbai.maticvigil.com/"));
    W3MChainPresets.chains.putIfAbsent('80001', () => W3MChainInfo(chainName: 'Test Token 1', chainId: '80001', namespace: 'eip155:80001', tokenName: "TT1", rpcUrl: "https://polygon-mumbai.g.alchemy.com/v2/1Hh1jM_H51CHnUnXDWiYwecKRkGtQhCc"));
    await _w3mService.init();
    print(_w3mService.isConnected);
    print(_w3mService.address);
    print(_w3mService.chainBalance);
    print(_w3mService.session);
    print(_w3mService.avatarUrl);

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
            children: [
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  openQrScanner(context);
                },
                child: const Text("QRCODE Scanner"),
              ),
              W3MConnectWalletButton(service: _w3mService),
              const SizedBox(
                height: 30,
              ),
              W3MNetworkSelectButton(service: _w3mService),
              const SizedBox(
                height: 30,
              ),
              W3MAccountButton(service: _w3mService),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(onPressed: (){}, child: Text('Send'),),
              W3M
            ],
          ),
        ),
      ),
    );
  }
}
