import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/api/api.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/util/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PostProvider extends ChangeNotifier {
  int reportCountToRemove = 99;

  CollectionReference post = FirebaseFirestore.instance.collection('posts');
  final Stream<QuerySnapshot> allPosts = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('created', descending: true)
      .snapshots();

  //
  // final Stream<QuerySnapshot> allComment = FirebaseFirestore.instance
  //     .collection('posts').doc();

  allComments(docId) {
    return FirebaseFirestore.instance.collection('posts').doc(docId).get();
  }

  addPost(context, text) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    return post.add({
      "uid": user.uid,
      "name": user.displayName,
      "image": user.photoUrl,
      "token": user.userToken,
      "type": "text",
      "post_text": text,
      "post_image": "",
      "image_path": "",
      "report": 0,
      "like": [],
      "comment": [],
      "created": DateTime.now()
    }).then((value) {
      showSnackBar(context, "Post Successful");
      Navigator.pop(context);
    }).catchError((e) => showSnackBar(context, "${e.code}"));
  }

  deletePost(context, docId, type, path) async {
    print(type);
    if (type == "text") {
      try {
        return post.doc(docId).delete().then((value) {
          showSnackBar(context, "Post Removed");
          notifyListeners();
        }).catchError((e) {
          showSnackBar(context, "$e");
          notifyListeners();
        });
      } catch (e) {
        print(e);
        // TODO
      }
    } else {
      try {
        return post.doc(docId).delete().then((value) {
          final storageRef = FirebaseStorage.instance.ref();
          final spaceRef = storageRef.child("$path");
          spaceRef
            ..delete().then((value) {
              showSnackBar(context, "Post Deleted");
            }).catchError((e) {
              print(e);
            });
          notifyListeners();
        }).catchError((e) {
          showSnackBar(context, "$e");
          notifyListeners();
        });
      } catch (e) {
        print(e);
        // TODO
      }
    }
  }

  addReport(context, docId, int reportNo) {
    print(reportNo == reportCountToRemove);
    if (reportNo == reportCountToRemove) {
      // deletePost(context, docId , );
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

  postLike(
    docId,
    uid,
    sendTo,
    name,
  ) {
    return post.doc(docId).update({
      "like": FieldValue.arrayUnion([uid])
    }).then((value) async {
      String to = sendTo;
      String title = "TGCD";
      String body = "$name liked your post";
      Map<String, String> data = {};
      await sendNotification(to, title, body, data);
    }).catchError((e) {
      print(e);
    });
  }

  removeLike(docId, uid) {
    return post.doc(docId).update({
      "like": FieldValue.arrayRemove([uid])
    });
  }

  commentOnPost(context, docId, uid, comment, name, image) {
    return post.doc(docId).update({
      "comment": FieldValue.arrayUnion([
        {
          "uid": "$uid",
          "name": name,
          "image": image,
          "comment": "$comment",
          "created": DateTime.now()
        }
      ])
    }).then((value) {
      return true;
    }).catchError((e) {
      print(e);
    });
  }

  showComment(docId) {}

  /// Add Image Post
  String finalImage = "";
  String imageName = "";

  pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    finalImage = image!.path;
    imageName = image.name;
    notifyListeners();
  }

  pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    finalImage = image!.path;
    imageName = image.name;
    notifyListeners();
  }

  cropImage(context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: "$finalImage",
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      finalImage = croppedFile.path;
      notifyListeners();
    }
    notifyListeners();
  }

  uploadImage(context, text) {
    final storageRef = FirebaseStorage.instance.ref();
    final postRef = storageRef.child(imageName.toString());
    final postImagesRef = storageRef.child("posts/${imageName.toString()}");

    final file = File(finalImage.toString());

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask =
        storageRef.child(postImagesRef.fullPath).putFile(file, metadata);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print(progress);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          print("Process");
          String url = await postImagesRef.getDownloadURL();
          postImage(context, text, url, postImagesRef.fullPath);
          break;
      }
    });
  }

  postImage(context, text, url, path) {
    var user = Provider.of<UserProvider>(context, listen: false);
    return post.add({
      "uid": user.uid,
      "name": user.displayName,
      "image": user.photoUrl,
      "token": user.userToken,
      "type": "image",
      "post_text": text,
      "post_image": url,
      "image_path": "$path",
      "report": 0,
      "like": [],
      "comment": [],
      "created": DateTime.now()
    }).then((value) {
      finalImage = "";
      imageName = "";
      showSnackBar(context, "Post Successful");
      Navigator.pop(context);
    }).catchError((e) => showSnackBar(context, "$e"));
  }

  /// Delete Automatic

  deleteAuto() {
    DateTime current = DateTime.now().subtract(Duration(minutes: 2));
    Timestamp _d = Timestamp.fromDate(current);
    Stream<QuerySnapshot> allPosts =
        FirebaseFirestore.instance.collection('posts').snapshots();

    allPosts.forEach((element) {
      print(element.size);
      element.docs.forEach((element) {
        Timestamp _t = element.get("created");
        DateTime _d = _t.toDate();

        ///Formula
        print(_d.add(Duration(minutes: 1)).isBefore(DateTime.now()));
        print(element.get("image_path"));
        if (_d.add(Duration(minutes: 30)).isBefore(DateTime.now())) {
          if (element.get("type") == "text") {
            post.doc(element.id).delete();
          } else {
            final storageRef = FirebaseStorage.instance.ref();
            final spaceRef = storageRef.child(element.get("image_path"));
            spaceRef.delete().then((value) {
              post.doc(element.id).delete().then((value) {}).catchError((e) {
                print(e);
              });
            }).catchError((e) {
              print(e);
            });
          }
        }
      });
    });
  }
}
