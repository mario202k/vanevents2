import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vanevents/models/ticket.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:vanevents/shared/topAppBar.dart';

class Tickets extends StatefulWidget {

  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Tickets({Key key, this.innerDrawerKey}) : super(key: key);
  
  
  
  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  Stream <List<Ticket>> streamTickets;
  
  
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreDatabase>(context, listen: false);
    streamTickets = db.streamTickets();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  TopAppBar(
                      'Billet',
                      true,
                          () => widget.innerDrawerKey.currentState.toggle(),
                      constraints.maxWidth),
                  StreamBuilder(
                    stream: streamTickets,
                    builder:
                      (context, snapshot){
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Erreur de connection'),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.secondary)),
                          );
                        }


                    
                  },)
                  
                  
                ],
              )),
        );
      }),
    );

//    return Column(
//      children: <Widget>[
//        SizedBox(height: 100,),
//        Container(
//          color: Colors.lightGreenAccent,
//          child: QrImage(
//            data: 'pi_1GW580JG3SDNUyPqDS4Mh7aV',
//            version: QrVersions.auto,
//            size: 320,
//            gapless: false,
//          ),
//        ),
//      ],
//    );
  }
}
