import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.user});

  final user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (user.id != null)
          ? ListView(
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
                  eyeStyle: const QrEyeStyle(
                      color: Color.fromARGB(195, 0, 0, 0),
                      eyeShape: QrEyeShape.square),
                  dataModuleStyle: const QrDataModuleStyle(
                      color: Color.fromARGB(195, 0, 0, 0),
                      dataModuleShape: QrDataModuleShape.circle),
                ),
                const ListTile(
                    title: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 26,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )),
                const ListTile(
                    title: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 26,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )),
              ],
            )
          : const Center(
              child: Text(
                'Connect to a wallet to see your profile',
              ),
            ),
    );
  }
}
