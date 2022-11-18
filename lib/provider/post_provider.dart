import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/util/widget.dart';

class PostProvider extends ChangeNotifier {
  int reportCountToRemove = 99;

  CollectionReference post = FirebaseFirestore.instance.collection('posts');
  final Stream<QuerySnapshot> allPosts = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('created', descending: true)
      .snapshots();

  addPost(context, text) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    return post
        .add({
          "uid": user.uid,
          "name": user.displayName,
          "image": user.photoUrl,
          "type": "text",
          "post_text": text,
          "report": 0,
          "like": [],
          "comment": [],
          "created": DateTime.now()
        })
        .then((value) => showSnackBar(context, "Post Successful"))
        .catchError((e) => showSnackBar(context, "${e.code}"));
  }

  deletePost(context, docId) {
    try {
      return post.doc(docId).delete().then((value) {
        showSnackBar(context, "Post Removed");
        notifyListeners();
      }).catchError((e) {
        showSnackBar(context, "${e.code}");
        notifyListeners();
      });
    } catch (e) {
      print(e);
      // TODO
    }
  }

  addReport(context, docId, int reportNo) {
    print(reportNo == reportCountToRemove);
    if (reportNo == reportCountToRemove) {
      deletePost(context, docId);
      notifyListeners();
    } else {
      return post
          .doc(docId)
          .update({"report": reportNo + 1})
          .then((value) => showSnackBar(context, "Post Reported"))
          .catchError((e) => print(e));
    }
    notifyListeners();
  }

  postLike(docId, uid) {
    return post.doc(docId).update({
      "like": FieldValue.arrayUnion([uid])
    });
  }

  removeLike(docId, uid) {
    return post.doc(docId).update({
      "like": FieldValue.arrayRemove([uid])
    });
  }

  commentOnPost(docId, uid, comment , name , image) {
    return post.doc(docId).update({
      "comment": FieldValue.arrayUnion([
        {"uid": "$uid","name":name , "image": image, "comment": "$comment", "created": DateTime.now()}
      ])
    });
  }
}
