import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/models/event.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/screens/qr_code_scanner.dart';
import 'package:vanevents/services/firestore_database.dart';

class AdminEvents extends StatefulWidget {
  @override
  _AdminEventsState createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  Stream streamEvents;
  List<Event> events = List<Event>();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<FirestoreDatabase>(context, listen: false);
    streamEvents = db.eventsStream();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Events'),
      ),
      body: StreamBuilder(
          stream: streamEvents,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erreur de connection'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary)),
              );
            }

            events.clear();

            events.addAll(snapshot.data);

            return ListView.separated(
              itemCount: events.length,
              itemBuilder:(context, index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Scanner',
                      color: Theme.of(context).colorScheme.secondary,
                      icon: FontAwesomeIcons.qrcode,
                      onTap: () => ExtendedNavigator.of(context).pushNamed(Routes.qrCodeScanner),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Update',
                      color: Theme.of(context).colorScheme.primaryVariant,
                      icon: FontAwesomeIcons.search,
                      onTap: () => ExtendedNavigator.of(context).pushNamed(Routes.uploadEvent, arguments: UploadEventArguments(idEvent: events.elementAt(index).id)),
                    )
                  ],
                  child: ListTile(
                    leading: Text(events.elementAt(index).titre),
                    title: Text(events.elementAt(index).status),
                    trailing: Icon(FontAwesomeIcons.qrcode),
                    onTap: ()=>ExtendedNavigator.of(context)
                        .pushNamed(Routes.qrCodeScanner),
                  ),
                );
              },
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(
                color:
                Theme.of(context).colorScheme.secondary,
                thickness: 1,
              ),
            );
            
            
            
            
          }),
    );
  }
}
