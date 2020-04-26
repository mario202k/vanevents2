import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vanevents/auth_widget.dart';
import 'package:vanevents/auth_widget_builder.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/screens/login.dart';
import 'package:vanevents/screens/walkthrough.dart';
import 'package:vanevents/services/firebase_auth_service.dart';
import 'package:vanevents/services/firestore_database.dart';
import 'package:custom_splash/custom_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(
        authServiceBuilder: (_) => FirebaseAuthService(),
        databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
        prefs: prefs));
  });
}

AsyncSnapshot<FirebaseUser> userSnapshotStatic;

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  MyApp({Key key, this.authServiceBuilder, this.databaseBuilder, this.prefs})
      : super(key: key);

  final ColorScheme colorScheme = ColorScheme(
      primary: const Color(0xFF790e8b),
      primaryVariant: const Color(0xFFdf78ef),
      secondary: const Color(0xFF218b0e),
      secondaryVariant: const Color(0xFF00600f),
      background: const Color(0xFF790e8b),
      surface: const Color(0xFF00600f),
      onBackground: const Color(0xFFFFFFFF),
      error: const Color(0xFF8b0e21),
      onError: const Color(0xFFFFFFFF),
      onPrimary: const Color(0xFF000000),
      onSecondary: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFFFFFFFF),
      brightness: Brightness.light);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
      ],
      child: AuthWidgetBuilder(
          databaseBuilder: databaseBuilder,
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> userSnapshot) {
            userSnapshotStatic = userSnapshot;
            return Material(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    colorScheme: colorScheme,
                    primaryColor: colorScheme.primary,
                    accentColor: colorScheme.secondary,
                    backgroundColor: colorScheme.background,
                    textTheme: TextTheme(
                      display1: GoogleFonts.raleway(
                        fontSize: 25.0,
                        color: colorScheme.onSurface,
                      ),
                      display2: GoogleFonts.raleway(
                        fontSize: 28.0,
                        color: colorScheme.onSurface,
                      ),
                      display3: GoogleFonts.raleway(
                        fontSize: 61.0,
                        color: colorScheme.onPrimary,
                      ),
                      display4: GoogleFonts.raleway(
                        fontSize: 98.0,
                        color: colorScheme.onPrimary,
                      ),
                      caption: GoogleFonts.sourceCodePro(
                        fontSize: 11.0,
                        color: colorScheme.onPrimary,
                      ),
                      headline: GoogleFonts.raleway(
                        fontSize: 35.0,
                        color: colorScheme.onBackground,
                      ),
                      subhead: GoogleFonts.sourceCodePro(
                        fontSize: 16.0,
                        color: colorScheme.onPrimary,
                      ),
                      overline: GoogleFonts.sourceCodePro(
                        fontSize: 11.0,
                        color: colorScheme.onPrimary,
                      ),
                      body2: GoogleFonts.sourceCodePro(
                        fontSize: 17.0,
                        color: colorScheme.onPrimary,
                      ),
                      subtitle: GoogleFonts.sourceCodePro(
                        fontSize: 14.0,
                        color: colorScheme.onPrimary,
                      ),
                      body1: GoogleFonts.sourceCodePro(
                        fontSize: 15.0,
                        color: colorScheme.onPrimary,
                      ),
                      title: GoogleFonts.sourceCodePro(
                        fontSize: 20.0,
                        color: colorScheme.onBackground,
                      ),
                      button: GoogleFonts.sourceCodePro(
                        fontSize: 15.0,
                        color: colorScheme.onBackground,
                      ),
                    ),

                    buttonTheme: ButtonThemeData(
                        textTheme: ButtonTextTheme.primary,
                        splashColor: colorScheme.primary,
                        colorScheme: colorScheme,
                        buttonColor: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        foregroundColor: colorScheme.secondary),
                    inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    cardTheme: CardTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    dividerColor: colorScheme.secondary),


                builder: ExtendedNavigator<Router>(
                  router: Router(),
                  initialRouteArgs: AuthWidgetArguments(
                      seenOnboarding: prefs.getBool('seen') ?? false),
                ),

                //onGenerateRoute: Router.onGenerateRoute,
//                    prefs.getBool('seen') ?? false),
              ),
            );
          }),
    );
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Firestore db = Firestore.instance;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.vaninamario.crossroads_events',
      'Crossroads Events',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  db
      .collection('chats')
      .document(message['data']['chatId'])
      .collection('messages')
      .document(message['data']['id'])
      .setData({'state': 1}, merge: true).then((_) {
    print('done!!!!');

  flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['data']['type'] == '0'
          ? message['notification']['body']
          : 'image',
      platformChannelSpecifics,
      payload: '');


  }).catchError((e) {
    print(e);
    print('merde');
  }); //message recu

  return Future<void>.value();

  // Or do other work.
}
