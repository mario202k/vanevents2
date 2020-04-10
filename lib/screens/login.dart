import 'package:auto_route/auto_route.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/routing/route.gr.dart';
import 'package:vanevents/services/firebase_auth_service.dart';
import 'package:vanevents/shared/card_form.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FocusScopeNode _nodeEmail = FocusScopeNode();
  final FocusScopeNode _nodePassword = FocusScopeNode();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  CardForm cardForm;
  bool _obscureTextSignupConfirm = true;
  GlobalKey key = GlobalKey();

  bool isDispose = false;

  double height = 4.30;
  bool startAnimation = false;
  ValueNotifier<bool> valueNotifier;
  FirebaseAuthService auth;

  void _togglePassword() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  _afterLayout(_) {
    if (!isDispose) {
      setState(() {
        height = _getSizes() / 45;
      });
    }
  }

  double _getSizes() {
    double height = 4.30;

    if (key.currentContext != null) {
      final RenderBox renderBoxRed = key.currentContext.findRenderObject();
      final sizeRed = renderBoxRed.size;
      height = sizeRed.height;
    }
    return height;
  }

  @override
  void dispose() {
    isDispose = true;
    _nodeEmail.dispose();
    _nodePassword.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.secondary,
      statusBarIconBrightness: Theme.of(context).colorScheme.brightness,
      systemNavigationBarColor: Theme.of(context).colorScheme.secondary,
      systemNavigationBarIconBrightness:
          Theme.of(context).colorScheme.brightness,
    ));

    auth = Provider.of<FirebaseAuthService>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,

//          gradient: LinearGradient(
//            colors: [
//              Theme.of(context).colorScheme.secondary,
//              Theme.of(context).colorScheme.primary
//
//            ],
//            begin: Alignment.topLeft,
//            end: Alignment.bottomRight,
//          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: viewportConstraints.maxHeight,
                      child: Opacity(
                        opacity: 0.4,
                        child: Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                              aspectRatio: 1.6,
                              child: FlareActor(
                                'assets/animations/dance.flr',
                                alignment: Alignment.center,
                                animation: 'dance',
                              )),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/img/vanlogo.png'),
                                  fit: BoxFit.fitHeight)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              CardForm(
                                formContent: ['Email', 'Mot de passe'],
                                textButton: 'Se connecter',
                                type: 'login',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        thickness: 1,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        'ou',
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(context).textTheme.button,
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        thickness: 1,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FloatingActionButton(
                                    onPressed: () {
                                      print('facebook');
                                    },
                                    backgroundColor: Colors.blue.shade800,
                                    child: Icon(
                                      FontAwesomeIcons.facebookF,
                                      color: Colors.white,
                                    ),
                                    heroTag: null,
                                  ),
                                  FloatingActionButton(
                                      onPressed: () {
                                        auth.googleSignIn().catchError((e) {
                                          print(e);
                                          auth.showSnackBar(
                                              'impossible de se connecter',
                                              context);
                                        });
                                      },
                                      backgroundColor: Colors.red.shade700,
                                      child: Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                      ),
                                      heroTag: null),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FlatButton(
                                onPressed: () => ExtendedNavigator.of(context)
                                    .pushNamed(Routes.signUp),
                                child: Text(
                                  'Pas de compte? S\'inscrire maintenant',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                onPressed: () => ExtendedNavigator.of(context)
                                    .pushNamed(Routes.resetPassword),
                                child: Text(
                                  'Mot de passe oublier?',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

//  onSubmit(GlobalKey<FormBuilderState> _fbKey,List<TextEditingController> _textEdit)async{
//    if (!_fbKey.currentState.validate()) {
//      auth.showSnackBar('Formulaire invalide', context);
//      return;
//    }
//    valueNotifier.value = true;
//    await auth
//        .signInWithEmailAndPassword(_email.text, _password.text)
//        .catchError((e) {
//      valueNotifier.value = false;
//      print(e);
//      auth.showSnackBar("email ou mot de passe invalide", context);
//    }).whenComplete((){
//      valueNotifier.value = false;
//    });
//    valueNotifier.value = false;
//  }
}
