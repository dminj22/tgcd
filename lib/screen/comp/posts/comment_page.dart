import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/post_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../util/widget.dart';

class CommentPage extends StatefulWidget {
  final docId;

  const CommentPage({Key? key, this.docId}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<PostProvider>(
      builder: (context, com, child) {
        return FutureBuilder<DocumentSnapshot>(
            future: com.allComments(widget.docId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                List c = snapshot.data!.get("comment");
                return Column(
                  children: [
                    snapshot.data!.get("comment").isNotEmpty
                        ? Expanded(
                            child: Consumer<UserProvider>(
                              builder: (context, provider, child) {
                                return ListView.builder(
                                  itemCount: c.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Timestamp d = c[index]["created"];
                                    return Column(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          leading: Visibility(
                                            visible:
                                                provider.uid != c[index]["uid"],
                                            child: CircleAvatar(
                                              child: AvatarImageHolder(
                                                url: c[index]["image"],
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "${c[index]["name"]}",
                                            textAlign:
                                                provider.uid == c[index]["uid"]
                                                    ? TextAlign.end
                                                    : TextAlign.start,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          subtitle: Text(
                                            "${c[index]["comment"]}",
                                            textAlign:
                                                provider.uid == c[index]["uid"]
                                                    ? TextAlign.end
                                                    : TextAlign.start,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          trailing: Visibility(
                                            visible:
                                                provider.uid == c[index]["uid"],
                                            child: CircleAvatar(
                                              child: AvatarImageHolder(
                                                url: c[index]["image"],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 19),
                                          child: Row(
                                            mainAxisAlignment:
                                                provider.uid == c[index]["uid"]
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  getTimeDifferenceFromNow(
                                                      d.toDate()),
                                                  style:
                                                      TextStyle(fontSize: 8)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: Text(
                            "Be the First one to comment",
                            style: TextStyle(color: Colors.black),
                          )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              cursorColor: Colors.black,
                              controller: commentController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: "Write a comment",
                                contentPadding: EdgeInsets.only(left: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                var user = Provider.of<UserProvider>(context,
                                    listen: false);
                                bool done = await context
                                    .read<PostProvider>()
                                    .commentOnPost(
                                        context,
                                        widget.docId,
                                        user.uid,
                                        commentController.text,
                                        user.displayName,
                                        user.photoUrl);
                                if (done)
                                  setState(() {
                                    commentController.clear();
                                  });
                              },
                              icon: Icon(
                                Icons.send,
                                color: commentController.text.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey.shade500,
                              ))
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      },
    ));
  }
}
