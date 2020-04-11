import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen/screen.dart';
import 'package:vanevents/models/ticket.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:after_init/after_init.dart';

class QrCode extends StatefulWidget {
  String data;

  QrCode(this.data);

  @override
  _QrCodeState createState() => _QrCodeState();
}




class _QrCodeState extends State<QrCode> with AfterInitMixin<QrCode> {

  double brightness;
  Stream <Ticket> streamTicket;

  @override
  void initState() {
    // Set the brightness:
    setBrightness();
    super.initState();
  }

  Future setBrightness() async {
    brightness = await Screen.brightness;
    Screen.setBrightness(1);
  }



  @override
  void dispose() {
    if(brightness != null){
      Screen.setBrightness(brightness);
    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: QrImage(
          data: widget.data,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
        ),
      ),
    );
  }

  @override
  void didInitState() {
    final db = Provider.of<FirestoreDatabase>(context, listen: false);
    streamTicket = db.streamTicket(widget.data);
    streamTicket.listen((data){
      if(data.status == 'Validé'){
        ExtendedNavigator.of(context).pop();
      }
    });
}
}
