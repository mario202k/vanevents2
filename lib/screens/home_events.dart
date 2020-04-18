import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/models/event.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:vanevents/shared/topAppBar.dart';

class HomeEvents extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const HomeEvents(this.innerDrawerKey);

  @override
  _HomeEventsState createState() => _HomeEventsState();
}

class _HomeEventsState extends State<HomeEvents> {
  Stream<List<Event>> slides;
  List<Event> events = List<Event>();
  bool isDispose = false;
  bool startAnimation = false;

  @override
  void didUpdateWidget(HomeEvents oldWidget) {

    //_afterLayout();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    if (!isDispose) {

      setState(() {
        startAnimation = !startAnimation;
      });
    }
  }

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreDatabase db =
        Provider.of<FirestoreDatabase>(context, listen: false);

    slides = db.eventsStream();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.secondary,
      statusBarIconBrightness: Theme.of(context).colorScheme.brightness,
      systemNavigationBarColor: Theme.of(context).colorScheme.secondary,
      systemNavigationBarIconBrightness:
          Theme.of(context).colorScheme.brightness,
    ));


//    _queryDb(false, auth);
//      SystemChrome.setPreferredOrientations([
//        DeviceOrientation.portraitUp,
//        DeviceOrientation.portraitDown,
//      ]);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: TopAppBar('Events', true,
            () => widget.innerDrawerKey.currentState.toggle(), double.infinity),
      ),
      //appBar: AppBar(backgroundColor: Colors.yellow,shape: CustomShapeBorder() ,) ,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: (constraints.maxHeight * 4.25) / 6,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: StreamBuilder<List<Event>>(
                  stream: slides,
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary)),
                      );
                    } else if (snap.hasError) {
                      print('Erreur de connection${snap.error.toString()}');
                      db.showSnackBar(
                          'Erreur de connection${snap.error.toString()}',
                          context);
                      print('Erreur de connection${snap.error.toString()}');
                      return Center(
                        child: Text(
                          'Erreur de connection',
                          style: Theme.of(context).textTheme.display1,
                        ),
                      );
                    } else if (!snap.hasData) {
                      print("pas data");
                      return Center(
                        child: Text('Pas d\'évenements'),
                      );
                    }

                    events.clear();
                    events.addAll(snap.data);

                    return Hero(
                      tag: '123',
                      child: snap.data.isNotEmpty
                          ? Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: events[index].imageUrl,
                                    placeholder: (context, url) => SizedBox(
                                      width:
                                          (constraints.maxHeight * 4.25) / 6,
                                      height: constraints.maxHeight,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                );
                              },
                              itemCount: events.length,
                              pagination: SwiperPagination(),
                              control: SwiperControl(
                                color:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              onTap: (index) {
                                ExtendedNavigator.of(context).pushNamed(
                                    Routes.details,
                                    arguments: DetailsArguments(
                                        event: events.elementAt(index)));
                              },
                              itemWidth:
                                  (constraints.maxHeight * 0.88 * 4.25) / 6,
                              itemHeight: constraints.maxHeight * 0.88,
                              layout: SwiperLayout.TINDER,
                              loop: true,
                              outer: false,
                              autoplay: true,
                              autoplayDisableOnInteraction: false,
                            )
                          : Center(
                              child: Text(
                                'Pas d\'évenements',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                    );
                  }),
            ),
          ),
        );
      }),
    );
  }

//  Stream _queryDb(bool upcoming, FirestoreDatabase db) {
//    if (upcoming) {
//      //Make a query
//      Query query = db.db.collection('events');
////          .where('dateDebut', isGreaterThanOrEqualTo: DateTime.now());
//
//      slides = query
//          .snapshots()
//          .map((list) => list.documents.map((doc) => doc.data));
//    } else {
//      //Make a query
//      Query query = db.db.collection('events');
////          .where('dateDebut', isLessThan: DateTime.now());
//
//      slides = query
//          .snapshots()
//          .map((list) => list.documents.map((doc) => doc.data));
//    }
//
//    return slides;
//  }
}


