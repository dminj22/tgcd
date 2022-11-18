import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllUserProvider extends ChangeNotifier {
  List<Map<String, dynamic>> listDobUser = [];
  getBirthDayUser() {
    DateTime _c = DateTime.now();
    listDobUser.clear();
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    _usersStream.forEach((element) {
      element.docs.forEach((element) {
        try {
          Timestamp dob = element["dob"];
          DateTime _date = dob.toDate();
          bool haveDob = DateTime(_date.year, _date.month, _date.day) ==
              DateTime(_c.year, _c.month, _c.day);
          if (haveDob) {
            listDobUser.add({
              "uid": element["uid"],
              "name": element["name"],
              "image": element["image"],
              "date": DateFormat('dd-MMMM-yyyy').format(_date)
            });
            notifyListeners();
            print(listDobUser);
          }
        } catch (e) {
          print("$e");
        }
        notifyListeners();
      });
      notifyListeners();
    });
    notifyListeners();
  }
}
