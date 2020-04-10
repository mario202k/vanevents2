// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vanevents/auth_widget.dart';
import 'package:vanevents/screens/login.dart';
import 'package:vanevents/screens/reset_password.dart';
import 'package:vanevents/screens/sign_up.dart';
import 'package:vanevents/screens/base_screen.dart';
import 'package:vanevents/screens/home_events.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:vanevents/screens/chat.dart';
import 'package:vanevents/screens/chat_room.dart';
import 'package:vanevents/screens/full_photo.dart';
import 'package:vanevents/screens/profile.dart';
import 'package:vanevents/screens/tickets.dart';
import 'package:vanevents/screens/upload_event.dart';
import 'package:vanevents/screens/details.dart';
import 'package:vanevents/models/event.dart';
import 'package:vanevents/screens/formula_choice.dart';
import 'package:vanevents/models/formule.dart';

abstract class Routes {
  static const authWidget = '/';
  static const login = '/login';
  static const resetPassword = '/reset-password';
  static const signUp = '/sign-up';
  static const baseScreens = '/base-screens';
  static const homeEvents = '/home-events';
  static const chat = '/chat';
  static const chatRoom = '/chat-room';
  static const fullPhoto = '/full-photo';
  static const profile = '/profile';
  static const tickets = '/tickets';
  static const uploadEvent = '/upload-event';
  static const details = '/details';
  static const formulaChoice = '/formula-choice';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.authWidget:
        if (hasInvalidArgs<AuthWidgetArguments>(args)) {
          return misTypedArgsRoute<AuthWidgetArguments>(args);
        }
        final typedArgs = args as AuthWidgetArguments ?? AuthWidgetArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthWidget(
              key: typedArgs.key, seenOnboarding: typedArgs.seenOnboarding),
          settings: settings,
        );
      case Routes.login:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Login(),
          settings: settings,
        );
      case Routes.resetPassword:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ResetPassword(),
          settings: settings,
        );
      case Routes.signUp:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignUp(),
          settings: settings,
        );
      case Routes.baseScreens:
        if (hasInvalidArgs<BaseScreensArguments>(args)) {
          return misTypedArgsRoute<BaseScreensArguments>(args);
        }
        final typedArgs =
            args as BaseScreensArguments ?? BaseScreensArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => BaseScreens(typedArgs.uid),
          settings: settings,
        );
      case Routes.homeEvents:
        if (hasInvalidArgs<HomeEventsArguments>(args)) {
          return misTypedArgsRoute<HomeEventsArguments>(args);
        }
        final typedArgs = args as HomeEventsArguments ?? HomeEventsArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => HomeEvents(typedArgs.innerDrawerKey),
          settings: settings,
        );
      case Routes.chat:
        if (hasInvalidArgs<ChatArguments>(args)) {
          return misTypedArgsRoute<ChatArguments>(args);
        }
        final typedArgs = args as ChatArguments ?? ChatArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => Chat(typedArgs.innerDrawerKey),
          settings: settings,
        );
      case Routes.chatRoom:
        if (hasInvalidArgs<ChatRoomArguments>(args)) {
          return misTypedArgsRoute<ChatRoomArguments>(args);
        }
        final typedArgs = args as ChatRoomArguments ?? ChatRoomArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChatRoom(typedArgs.myId, typedArgs.nomFriend,
              typedArgs.imageFriend, typedArgs.chatId, typedArgs.friendId),
          settings: settings,
        );
      case Routes.fullPhoto:
        if (hasInvalidArgs<FullPhotoArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<FullPhotoArguments>(args);
        }
        final typedArgs = args as FullPhotoArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => FullPhoto(key: typedArgs.key, url: typedArgs.url),
          settings: settings,
        );
      case Routes.profile:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Profile(),
          settings: settings,
        );
      case Routes.tickets:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Tickets(),
          settings: settings,
        );
      case Routes.uploadEvent:
        return MaterialPageRoute<dynamic>(
          builder: (_) => UploadEvent(),
          settings: settings,
        );
      case Routes.details:
        if (hasInvalidArgs<DetailsArguments>(args)) {
          return misTypedArgsRoute<DetailsArguments>(args);
        }
        final typedArgs = args as DetailsArguments ?? DetailsArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => Details(typedArgs.event),
          settings: settings,
        );
      case Routes.formulaChoice:
        if (hasInvalidArgs<FormulaChoiceArguments>(args)) {
          return misTypedArgsRoute<FormulaChoiceArguments>(args);
        }
        final typedArgs =
            args as FormulaChoiceArguments ?? FormulaChoiceArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => FormulaChoice(typedArgs.formulas),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//AuthWidget arguments holder class
class AuthWidgetArguments {
  final Key key;
  final bool seenOnboarding;
  AuthWidgetArguments({this.key, this.seenOnboarding});
}

//BaseScreens arguments holder class
class BaseScreensArguments {
  final String uid;
  BaseScreensArguments({this.uid});
}

//HomeEvents arguments holder class
class HomeEventsArguments {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  HomeEventsArguments({this.innerDrawerKey});
}

//Chat arguments holder class
class ChatArguments {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  ChatArguments({this.innerDrawerKey});
}

//ChatRoom arguments holder class
class ChatRoomArguments {
  final String myId;
  final String nomFriend;
  final String imageFriend;
  final String chatId;
  final String friendId;
  ChatRoomArguments(
      {this.myId,
      this.nomFriend,
      this.imageFriend,
      this.chatId,
      this.friendId});
}

//FullPhoto arguments holder class
class FullPhotoArguments {
  final Key key;
  final String url;
  FullPhotoArguments({this.key, @required this.url});
}

//Details arguments holder class
class DetailsArguments {
  final Event event;
  DetailsArguments({this.event});
}

//FormulaChoice arguments holder class
class FormulaChoiceArguments {
  final List<Formule> formulas;
  FormulaChoiceArguments({this.formulas});
}
