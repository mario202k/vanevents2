import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Tickets extends StatefulWidget {
  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 100,),
        Container(
          color: Colors.lightGreenAccent,
          child: QrImage(
            data: 'pi_1GW580JG3SDNUyPqDS4Mh7aV',
            version: QrVersions.auto,
            size: 320,
            gapless: false,
          ),
        ),
      ],
    );
  }
}
