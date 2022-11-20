import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/auth_provider.dart';
import 'package:tgcd/provider/notification.dart';
import 'package:tgcd/provider/post_provider.dart';
import 'package:tgcd/screen/add_post_screen.dart';
import 'package:tgcd/screen/comp/birthday_comp.dart';
import 'package:tgcd/screen/profile_screen.dart';
import 'package:tgcd/util/widget.dart';
import '../provider/all_user_provider.dart';
import '../provider/user_provider.dart';
import 'comp/posts/show_post_comp.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<AllUserProvider>().getBirthDayUser());
    Future.microtask(
        () => context.read<UserProvider>().getUserProfile(context));
    Future.microtask(() => context.read<PostProvider>().deleteAuto());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<UserProvider>(
          builder: (context, user, child) {
            return user.photoUrl != null
                ? Hero(
                    tag: "profile",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AvatarImageHolder(
                          url: user.photoUrl,
                        ),
                      ),
                    ),
                  )
                : CircularProgressIndicator();
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                context.read<AuthProvider>().logOut(context);
              },
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.purple),
              ))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPostScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 20),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30)),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "What's in your mind...",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Icon(
                          Icons.photo,
                          size: 20,
                        )
                      ],
                    ),
                  )),
            ),
          ),
          // BirthDayComp(),
          ShowPostComp(),
        ],
      ),
    );
  }
}
