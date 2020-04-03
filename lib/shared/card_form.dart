import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vanevents/services/firebase_auth_service.dart';
import 'package:after_init/after_init.dart';

class CardForm extends StatefulWidget {
  final List<String> formContent;
  final String textButton;
  final String type;

  CardForm({Key key, this.formContent, this.textButton, this.type})
      : super(key: key);

  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> with AfterInitMixin<CardForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<FocusScopeNode> _nodes;
  List<TextEditingController> _textEdit;
  GlobalKey key = GlobalKey();
  bool isDispose = false;
  double height = 4.30;
  bool startAnimation = false;
  FirebaseAuthService auth;



  _afterLayout(_) {
    if (!isDispose) {
      setState(() {
        height = _getSizes() / 56.5;
      });
    }
  }

  double _getSizes() {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    return sizeRed.height;
  }

  @override
  void initState() {
    _nodes = List<FocusScopeNode>.generate(
      widget.formContent.length,
      (index) => FocusScopeNode(),
    );
    _textEdit = List<TextEditingController>.generate(
        widget.formContent.length, (index) => TextEditingController());

    super.initState();
  }


  @override
  void didInitState() {

  }

  @override
  void didUpdateWidget(CardForm oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    isDispose = true;
    _textEdit.forEach((textEdit) => textEdit.dispose());
    _nodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    auth = Provider.of<FirebaseAuthService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Stack(
        children: <Widget>[
          Card(
            key: key,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(children: List<Widget>.generate(
                    widget.formContent.length, (index) => buildFormBuilder(index))),
              ),
            ),
          ),
          FractionalTranslation(
              translation: Offset(0.0, height),
              child: Align(
                alignment: FractionalOffset(0.5, 0.0),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: !startAnimation
                      ? RaisedButton(
                          color: Theme.of(context).colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              widget.textButton,
                            ),
                          ),
                          onPressed: () {
                            onSubmit();
                          })
                      : CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary)),
                ),
              )),
        ],
      ),
    );
  }


  onSubmit() async {
    if (!_fbKey.currentState.validate()) {
      auth.showSnackBar('Formulaire invalide', context);
      return;
    }
    setState(() {
      startAnimation = true;
    });

    switch (widget.type) {
      case 'login':
        await auth
            .signInWithEmailAndPassword(
                _textEdit.elementAt(0).text, _textEdit.elementAt(1).text)
            .catchError((e) {
          setState(() {
            startAnimation = false;
          });
          print(e);
          auth.showSnackBar("email ou mot de passe invalide", context);
        }).whenComplete(() {
          setState(() {
            startAnimation = false;
          });
        });
        break;
    }
  }

  Widget buildFormBuilder(int index) {
    TextInputType textInput;
    List<FormFieldValidator> validators = List<FormFieldValidator>();
    Icon icon;
    IconButton iconButton;
    final toggle = Provider.of<ValueNotifier<bool>>(context, listen: false);

    switch (widget.formContent.elementAt(index)) {
      case 'Nom':
        textInput = TextInputType.text;
        validators = [
          FormBuilderValidators.required(errorText: 'Champs requis'),
          (val) {
            RegExp regex = RegExp(
                r'^[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ]{2,15}$');

            if (regex.allMatches(val).length == 0) {
              return 'Entre 2 et 15, ';
            }
          },
        ];
        icon = Icon(
          FontAwesomeIcons.user,
          size: 22.0,
          color: Theme.of(context).colorScheme.onSurface,
        );

        break;
      case 'Email':
        textInput = TextInputType.emailAddress;
        validators = [
          FormBuilderValidators.required(errorText: 'Champs requis'),
          FormBuilderValidators.email(
              errorText: 'Veuillez saisir un Email valide'),
        ];
        icon = Icon(
          FontAwesomeIcons.at,
          size: 22.0,
          color: Theme.of(context).colorScheme.onSurface,
        );

        break;
      case 'Mot de passe':
        textInput = TextInputType.text;
        validators = [
          FormBuilderValidators.required(errorText: 'Champs requis'),
          (val) {
            RegExp regex = new RegExp(
                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d.*)[a-zA-Z0-9\S]{8,15}$');
            if (regex.allMatches(val).length == 0) {
              return 'Entre 8 et 15, 1 majuscule, 1 minuscule, 1 chiffre';
            }
          },
        ];
        icon = Icon(
          FontAwesomeIcons.key,
          size: 22.0,
          color: Theme.of(context)
              .colorScheme
              .onSurface,
        );

        iconButton = IconButton(
          onPressed: (){
            setState(() {
              toggle.value = !toggle.value;

            });
          },
          color: Theme.of(context)
              .colorScheme
              .onSurface,
          iconSize: 20,
          icon: Icon(FontAwesomeIcons.eye),
        );
        break;
      case 'Confirmation':
        textInput = TextInputType.text;
        validators = [
          FormBuilderValidators.required(errorText: 'Champs requis'),
          (val) {
            if (_textEdit.elementAt(index - 1).text != val)
              return 'Pas identique';
          },
        ];
        icon = Icon(
          FontAwesomeIcons.key,
          size: 22.0,
          color: Theme.of(context)
              .colorScheme
              .onSurface,
        );

        iconButton = IconButton(
          onPressed: (){
            setState(() {
              toggle.value = !toggle.value;
            });
          },
          color: Theme.of(context)
              .colorScheme
              .onSurface,
          iconSize: 20,
          icon: Icon(FontAwesomeIcons.eye),
        );
        break;
    }



    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Consumer<ValueNotifier<bool>>(

        builder: (_,bool,__) => FormBuilderTextField(
          keyboardType: textInput,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          cursorColor: Theme.of(context).colorScheme.onSurface,
          attribute: widget.formContent.elementAt(index),
          maxLines: 1,
          obscureText: bool.value ,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 2),
                  borderRadius: BorderRadius.circular(25.0)),
              labelText: widget.formContent.elementAt(index),
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              border: InputBorder.none,
              errorStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              icon: icon,
          suffixIcon: iconButton),
          focusNode: _nodes.elementAt(index),
          onEditingComplete: () {

            String field = widget.formContent.elementAt(index);
            if (_fbKey.currentState.fields[field]
                .currentState
                .validate()) {
              _nodes.elementAt(index).unfocus();

              if (_nodes.length-1 != index) {
                FocusScope.of(context).requestFocus(_nodes.elementAt(index + 1));
              } else {
                onSubmit();
              }
            }
          },
          controller: _textEdit.elementAt(index),
          onChanged: (val){
            if (_textEdit.elementAt(index).text.length == 0) {
              _textEdit.elementAt(index).clear();
            }
          },
          validators: validators,
        ),
      ),
    );
  }
}
