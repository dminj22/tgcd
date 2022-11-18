import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/landing_screen.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/screen/avatar_screen.dart';
import 'package:tgcd/screen/dashboard_screen.dart';
import 'package:tgcd/screen/login_screen.dart';
import 'package:tgcd/util/widget.dart';

class AuthProvider extends ChangeNotifier {
  var verifyId;
  bool showOtp = false;

  Future<dynamic>? userLoggedIn;

  userAuthStatus(context) async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          userLoggedIn = Future.value(1);
          print('User is currently signed out!');
          notifyListeners();
        } else if (user.displayName == null) {
          userLoggedIn = Future.value(2);
          print('User Information InComplete');
          notifyListeners();
        } else {
          userLoggedIn = Future.value(3);
          print('User is signed in!');
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
      // TODO
    }
    notifyListeners();
  }

  sendOtp(context, mobile) async {
    showOtp = false;
    verifyId = null;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$mobile',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          showSnackBar(context, "Invalid Phone Number");
        } else {
          showSnackBar(context, "${e.code}");
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verifyId = verificationId;
        showOtp = true;
        showSnackBar(context, "Otp send to +91$mobile");
        notifyListeners();
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
    );
    notifyListeners();
  }

  verifyOtp(context, smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId, smsCode: smsCode);
    await auth.signInWithCredential(credential).then((value) {
      if (value.user!.uid.isNotEmpty) {
        if (value.additionalUserInfo!.isNewUser ||
            value.user!.displayName == null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AvatarScreen()));
        } else {
          showSnackBar(context, "Welcome ${value.user!.displayName}");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        }
      }
    }).catchError((e) {
      if (e.code == "invalid-verification-code") {
        showSnackBar(context, "Invalid Code");
      } else {
        showSnackBar(context, "${e.code}");
      }
    });
    notifyListeners();
  }

  logOut(context) async {
    print("Logout User");
    await FirebaseAuth.instance.signOut().then((value) {
      showOtp = false;
      verifyId = null;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
          (route) => false);
    });
  }
}
