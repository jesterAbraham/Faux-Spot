import 'dart:developer';

import 'package:faux_spot/app/routes/routes.dart';
import 'package:faux_spot/app/screen/login/model/emai_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../routes/messenger.dart';
import '../../home/view/location_widget.dart';
import '../service/login_signup_service.dart';

class SignupProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  bool loginOrSignup = false;
  bool isLoading = false;
  bool showOtpWidget = false;
  bool otpSucsess = false;

  void changePage() async {
    showOtpWidget = false;
    loginOrSignup = !loginOrSignup;
    notifyListeners();
  }

  //================================ VERIFY EMAIL ======================================

  final formKeySignup = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void verifyEmail() async {
    isLoading = true;
    notifyListeners();
    if (!formKeySignup.currentState!.validate()) {
      isLoading = false;
      notifyListeners();
      return;
    }

    if (!hasPasswordOneNumber && !isPasswordEightCharacters) {
      Messenger.pop(msg: "Set a strong password");
      isLoading = false;
      notifyListeners();
      return;
    }

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    EmailSignupRespones? respones =
        await LoginSignupService().signupEmail(email, password);

    if (respones != null) {
      if (respones.error == true) {
        await storage.write(key: "id", value: respones.id);
        Messenger.pop(msg: respones.message.toString());
        showOtpWidget = true;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        Messenger.pop(msg: respones.message.toString());
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  //================================ VERIFY EMAIL OTP ======================================

  void verifyOtp() async {
    isLoading = true;
    notifyListeners();

    if (!formKeySignup.currentState!.validate()) {
      isLoading = false;
      notifyListeners();
      return;
    }
    String? id = await storage.read(key: "id");
    String otp = otpController.text.trim();

    EmailVerifyRespones? respones =
        await LoginSignupService().verifyEmailOtp(otp, id!);
    if (respones!.error == true) {
      storage.write(key: "refreshToken", value: respones.refreshToken);
      storage.write(key: "token", value: respones.token);
      storage.write(key: "login", value: "true");
      Routes.pushRemoveUntil(screen: const LocationPick());
      isLoading = false;
      notifyListeners();
    } else {
      Messenger.pop(msg: respones.message.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  //================================ CHECK PASSWORD ======================================

  bool isPasswordEightCharacters = false;
  bool hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    log(password);
    notifyListeners();

    isPasswordEightCharacters = false;
    if (password.length >= 8) {
      isPasswordEightCharacters = true;
    }

    hasPasswordOneNumber = false;
    if (numericRegex.hasMatch(password)) {
      hasPasswordOneNumber = true;
    }
  }
}
