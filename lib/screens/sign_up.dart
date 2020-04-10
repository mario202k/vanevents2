import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/services/firebase_auth_service.dart';
import 'package:vanevents/shared/card_form.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File _image;

  final double _heightContainer = 120;

  bool startAnimation = false;

  Future _getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future _getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  final FocusScopeNode _nodeEmail = FocusScopeNode();
  final FocusScopeNode _nodePassword = FocusScopeNode();
  final FocusScopeNode _nodeName = FocusScopeNode();
  final FocusScopeNode _nodeConfirmation = FocusScopeNode();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();

  bool _obscureTextSignupConfirm = true;

  bool _obscureTextLogin = true;

  double _height = 10.64;
  GlobalKey key = GlobalKey();

  _afterLayout(_) {
    if (startAnimation == false) {
      setState(() {
        startAnimation = !startAnimation;
      });

    }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

  }

  @override
  void dispose() {

//    _name.dispose();
//    _email.dispose();
//    _password.dispose();
//    _confirmation.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      //print(state.toString());
      if (state == AppLifecycleState.resumed) {
        //print('onresumed!!!!!');
        _afterLayout;
      }
    });
  }

  void _togglePassword() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  ValueChanged _onChanged(val) {
    //print(val);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  double _getSizes() {
    //WidgetsBinding.instance.addPostFrameCallback();
    if(key.currentContext != null){
      final RenderBox renderBoxRed = key.currentContext.findRenderObject();
      final sizeRed = renderBoxRed.size;

      return sizeRed.height;
    }

    //print("SIZE of Red: $sizeRed");
  }

  void showSnackBar(String val, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: Duration(seconds: 3),
        content: Text(
          val,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        )));
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    final FirebaseAuthService auth =
    Provider.of<FirebaseAuthService>(context, listen: false);

//    _auth = ModalRoute.of(context).settings.arguments;



    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
                minWidth: viewportConstraints.maxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipPath(
                    clipper: ClippingClass(),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      height: startAnimation ? _heightContainer : 0,
                      width: viewportConstraints.maxWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ]),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            icon: Icon(
                              Platform.isAndroid
                                  ? Icons.arrow_back
                                  : Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      width: startAnimation
                          ? viewportConstraints.maxWidth - 50
                          : 0,
                      child: CardForm(formContent: ['Nom','Email','Mot de passe','Confirmation'],textButton: 'S\'inscrire',type: 'signup', ),
                    ),
                  ),
                  ClipPath(
                    clipper: ClippingClassBottom(),
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      height: startAnimation ? _heightContainer : 0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
//              child: Column(
//
//                children: <Widget>[
//                  CircleAvatar(
//                      backgroundImage: _image != null
//                          ? FileImage(_image)
//                          : AssetImage('assets/img/normal_user_icon.png'),
////                      Icon(FontAwesomeIcons.userAlt)
//                      radius: 50,
//                      child: RawMaterialButton(
//                        shape: const CircleBorder(),
//                        splashColor: Colors.black45,
//                        onPressed: () {
//                          showDialog<void>(
//                            context: context,
//                            builder: (BuildContext context) {
//                              return PlatformAlertDialog(
//                                title: Text('Source?',style: Theme.of(context).textTheme.display1,),
//                                actions: <Widget>[
//                                  PlatformDialogAction(
//                                    child: Text('Caméra',style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold),),
//                                    onPressed: () {
//                                      Navigator.of(context).pop();
//                                      _getImageCamera();
//                                    },
//                                  ),
//                                  PlatformDialogAction(
//                                    child: Text('Galerie',style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.bold),),
//                                    //actionType: ActionType.,
//                                    onPressed: () {
//                                      Navigator.of(context).pop();
//                                      _getImageGallery();
//                                    },
//
//                                  ),
//                                ],
//                              );
//                            },
//                          );
//                        },
//                        padding: const EdgeInsets.all(50.0),
//                      )),
//                ],
//              ),
            ),
          );
        }),
      ),
    );
  }
}

class ClippingClassBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.7);

    //path.lineTo(0.0, size.height);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    path.lineTo(size.width, size.height * 0.3);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
