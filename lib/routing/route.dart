import 'package:auto_route/auto_route_annotations.dart';
import 'package:vanevents/auth_widget.dart';
import 'package:vanevents/screens/admin_event.dart';
import 'package:vanevents/screens/base_screen.dart';
import 'package:vanevents/screens/chat_room.dart';
import 'package:vanevents/screens/details.dart';
import 'package:vanevents/screens/formula_choice.dart';
import 'package:vanevents/screens/full_photo.dart';
import 'package:vanevents/screens/login.dart';
import 'package:vanevents/screens/qr_code.dart';
import 'package:vanevents/screens/monitoring_scanner.dart';
import 'package:vanevents/screens/reset_password.dart';
import 'package:vanevents/screens/sign_up.dart';
import 'package:vanevents/screens/upload_event.dart';

@MaterialAutoRouter()
class $Router {
//flutter packages pub run build_runner build
  @initial
  AuthWidget authWidget;

  Login login;

  ResetPassword resetPassword;

  SignUp signUp;

  BaseScreens baseScreens;

  ChatRoom chatRoom;

  FullPhoto fullPhoto;

  UploadEvent uploadEvent;

  Details details;

  FormulaChoice formulaChoice;

  QrCode qrCode;

  MonitoringScanner monitoringScanner;

  AdminEvents adminEvents;
}
