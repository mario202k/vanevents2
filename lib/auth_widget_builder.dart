import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/models/user.dart';
import 'package:vanevents/services/firebase_auth_service.dart';
import 'package:vanevents/services/firestore_database.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder(
      {Key key, @required this.builder, @required this.databaseBuilder})
      : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<FirebaseUser>) builder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    print('authwidgetbuilder');
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder<FirebaseUser>(
      stream: authService.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {

        final FirebaseUser user = snapshot.data;
        if (user != null && user.isEmailVerified) {

          databaseBuilder(context, user.uid).createUserOnDatabase(user);

          return MultiProvider(
            providers: [
              StreamProvider<User>.value(
                value: databaseBuilder(context, user.uid).userStream(),
                initialData: toUser(user),
                catchError: (_, __) => toUser(user),
              ),
              Provider<FirestoreDatabase>(
                create: (context) => databaseBuilder(context, user.uid),
              ),
              ChangeNotifierProvider<ValueNotifier<bool>>(
                create: (context) => ValueNotifier<bool>(false),
              ),
              // NOTE: Any other user-bound providers here can be added here
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }

  User toUser(FirebaseUser firebaseUser) {
    return User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        imageUrl: firebaseUser.photoUrl,
        nom: firebaseUser.displayName);
  }
}
