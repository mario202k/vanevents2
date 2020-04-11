import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vanevents/models/ticket.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:vanevents/shared/topAppBar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Tickets extends StatefulWidget {

  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Tickets({Key key, this.innerDrawerKey}) : super(key: key);
  
  
  
  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  Stream <List<Ticket>> streamTickets;
  List<Ticket> tickets = List<Ticket>();
  
  
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
                    initialData: [],
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

                        tickets.clear();
                        tickets.addAll(snapshot.data);

                        return ListView.separated(
                          itemCount: tickets.length,
                          itemBuilder:(context, index) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Rembourser',
                                  color: Theme.of(context).colorScheme.secondary,
                                  icon: FontAwesomeIcons.moneyBillWave,
                                  onTap: () => db.showSnackBar('Archive', context),
                                ),
                              ],
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Detail',
                                  color: Theme.of(context).colorScheme.primaryVariant,
                                  icon: FontAwesomeIcons.search,
                                  onTap: () => db.showSnackBar('Search', context),
                                )
                              ],
                              child: ListTile(
                                leading: dateDachat(tickets.elementAt(index).dateTime),
                                title: Text(tickets.elementAt(index).status),
                                trailing: Icon(FontAwesomeIcons.qrcode),
                                onTap: ()=>ExtendedNavigator.of(context)
                                    .pushNamed(Routes.qrCode,arguments: QrCodeArguments(data:tickets.elementAt(index).id) ),
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


                    
                  },)
                  
                  
                ],
              )),
        );
      }),
    );
  }

  Widget dateDachat(DateTime dateTime) {

    final date = DateFormat('dd/MM/yy',);

    return Text(date.format(dateTime));


  }
}
