import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vanevents/main.dart';
import 'package:vanevents/screens/base_screen.dart';
import 'package:vanevents/screens/login.dart';
import 'package:vanevents/screens/walkthrough.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatefulWidget {

  final bool seenOnboarding;
  const AuthWidget({Key key, this.seenOnboarding})
      : super(key: key);


  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {


  @override
  Widget build(BuildContext context) {

    if (userSnapshotStatic.connectionState == ConnectionState.active) {

      return userSnapshotStatic.hasData
          ? BaseScreens(userSnapshotStatic.data.uid)

          : CustomSplash(
            imagePath: 'assets/img/vanlogo.png',
            backGroundColor: Theme.of(context).colorScheme.background,
            // backGroundColor: Color(0xfffc6042),
            animationEffect: 'fade-in',
            logoSize: 200,
            home: Login(),
            customFunction: () {
              if (widget.seenOnboarding) {
                return 1;
              } else {
                return 2;
              }
            },
            duration: 2500,
            type: CustomSplashType.StaticDuration,
            outputAndHome: {1: Login(), 2: Walkthrough()},
          );
    }


    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
