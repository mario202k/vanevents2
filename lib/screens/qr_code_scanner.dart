import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  GlobalKey qrKey = GlobalKey();
  String data = '';


  Future _scanQR() async {
    try {
      String qrResult = await MajaScan.startScan(
          title: "QRcode scanner",
          titleColor: Colors.amberAccent[700],
          qRCornerColor: Colors.orange,
          qRScannerColor: Colors.orange);
      setState(() {
        data = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          data = "Camera permission was denied";
        });
      } else {
        setState(() {
          data = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        data = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        data = "Unknown Error $ex";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr'),
      ),
      body: Center(child: Text(data)),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
