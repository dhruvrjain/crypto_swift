import 'package:crypto_swift/model/user.dart';
import 'package:crypto_swift/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  void openQrScanner(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> QrScanner()));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Scaffold(
        appBar: AppBar(title: const Text('CryptoSwift')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  accountName: Text(user.name),
                  accountEmail: Text(user.walletAddress),
                  currentAccountPicture: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      child: Text(
                        user.name[0],
                      ),
                    ),
                  ),
                ),
              ),
              QrImageView(
                data: '{ walletAddress: ${user.walletAddress} }',
                // embeddedImage: const AssetImage('assets/images/appLogo.png',),
                eyeStyle: const QrEyeStyle(color: Color.fromARGB(195, 0, 0, 0),eyeShape: QrEyeShape.square),
                dataModuleStyle: const QrDataModuleStyle(color: Color.fromARGB(195, 0, 0, 0),dataModuleShape: QrDataModuleShape.circle),
              ),
              const ListTile(title: Row(
                children: [
                  Icon(Icons.person,size: 26,),
                  SizedBox(width: 30,),
                  Text('Profile',style: TextStyle(fontSize: 18,),),
                ],
              )),
              const ListTile(title: Row(
                children: [
                  Icon(Icons.settings,size: 26,),
                  SizedBox(width: 30,),
                  Text('Settings',style: TextStyle(fontSize: 18,),),
                ],
              )),
            ],
          ),
        ),
        body: Column(
          children: [
            Text("Sample 1"),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                openQrScanner(context);
              },
              child: Text("QRCODE Scanner"),
            )
          ],
        ),
      ),
    );
  }
}
