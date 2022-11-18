import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Posts",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Consumer<PostProvider>(
            builder: (context, provider, child) {
              return ElevatedButton(
                onPressed: () {
                  if (provider.finalImage.isNotEmpty) {
                    provider.uploadImage(context, postController.text);
                  } else {
                    provider.addPost(context, postController.text);
                  }
                  postController.clear();
                },
                child: Text("POST"),
              );
            },
          ),
        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                context.read<PostProvider>().pickImageFromGallery();
              },
              icon: Icon(Icons.image)),
          IconButton(
              onPressed: () {
                context.read<PostProvider>().pickImageFromCamera();
              },
              icon: Icon(Icons.camera)),
          IconButton(onPressed: () {}, icon: Icon(Icons.location_on)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded)),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            TextField(
              maxLines: null,
              controller: postController,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              cursorColor: Colors.grey,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "What's in your mind",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
            Consumer<PostProvider>(
              builder: (context, image, child) {
                return image.finalImage.isNotEmpty
                    ? Stack(
                        children: [
                          Image.file(
                            File(image.finalImage),
                          ),
                          Container(
                            color: Colors.white.withOpacity(.2),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      image.finalImage = "";
                                      image.imageName = "";
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      image.cropImage(context);
                                    },
                                    icon: Icon(
                                      Icons.mode_edit_outline_rounded,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          )
                        ],
                      )
                    : Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
