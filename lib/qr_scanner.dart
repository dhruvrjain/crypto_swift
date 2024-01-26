import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});
  @override
  State<StatefulWidget> createState() {
    return _QrScannerState();
  }
}

class _QrScannerState extends State<QrScanner> {
  String qrResult='null';

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#fff666', 'Return', true, ScanMode.QR);
          if(!mounted) return;
          setState(() {
            qrResult=qrCode.toString();
          });
    } on PlatformException {
      qrResult = 'null';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Athu')),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Center(
                child: Column(
              children: [
                Text('$qrResult'),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed:scanQR,
                  child: Text(
                    'Scan now',
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
