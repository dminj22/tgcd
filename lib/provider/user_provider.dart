import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tgcd/screen/dashboard_screen.dart';
import 'package:tgcd/util/widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProvider extends ChangeNotifier {
  var uid;
  var displayName;
  var phoneNumber;
  var photoUrl;
  var userToken;
  Timestamp? dob;

  updateUserProfile(context, displayName, photoURL) async {
    final user = FirebaseAuth.instance.currentUser;
    await user!.updateDisplayName(displayName).then((value) async {
      await user.updatePhotoURL(photoURL).then((value) async {
        bool step2 = await getUserProfile(context);
        if (step2) {
          showSnackBar(context, "Welcome $displayName");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        }
        notifyListeners();
      }).catchError((e) {
        showSnackBar(context, e.code);
      });
      notifyListeners();
    }).catchError((e) {
      showSnackBar(context, e.code);
    });
    notifyListeners();
  }

  getUserProfile(context) async {
    final storageRef = FirebaseStorage.instance.ref();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      displayName = user.displayName;
      phoneNumber = user.phoneNumber;
      photoUrl = await storageRef.child("${user.photoURL}").getDownloadURL();
      bool done = await addUserInformationToDatabase(context);
      notifyListeners();
      if (done) {
        return true;
      } else {
        return false;
      }
    }
    notifyListeners();
  }

  addUserInformationToDatabase(context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    userToken = token;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    bool done = await users.doc(uid).set({
      "uid": uid,
      "name": displayName,
      "number": phoneNumber,
      "image": photoUrl,
      "token": token
    }, SetOptions(merge: true)).then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
    return done;
  }

  addDOB(context, date) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(uid).set({"dob": DateTime.parse(date.toString())},
        SetOptions(merge: true)).then((value) {
      showSnackBar(context, "DOB Added");
      getDob();
    });
  }

  showDate(context) async {
    DateTime? _date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (_date != null) {
      addDOB(context, _date);
    }
  }

  getDob() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot data = await users.doc(uid).get();
    try {
      dob = data["dob"];
      print("${data["dob"]} >>>>>>>>>>>>>>>>>>>>>>>>>>");
    } catch (e) {
      dob = null;
      print(e);
    }
    notifyListeners();
  }

  getUserImage(otherId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot data = await users.doc(otherId).get();
    return [data["image"], data["name"]];
  }
}
