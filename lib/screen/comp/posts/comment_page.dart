import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/post_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../util/widget.dart';

class CommentPage extends StatefulWidget {
  final List? comment;
  final docId;

  const CommentPage({Key? key, this.comment, this.docId}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        widget.comment!.isNotEmpty
            ? Expanded(
                child: Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: widget.comment!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Timestamp d = widget.comment![index]["created"];
                        return Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: Visibility(
                                visible: provider.uid != widget.comment![index]["uid"],
                                child: CircleAvatar(
                                  child: AvatarImageHolder(
                                    url: widget.comment![index]["image"],
                                  ),
                                ),
                              ),
                              title: Text(
                                "${widget.comment![index]["name"]}",
                                textAlign:
                                    provider.uid == widget.comment![index]["uid"]
                                        ? TextAlign.end
                                        : TextAlign.start,
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Text(
                                "${widget.comment![index]["comment"]}",
                                textAlign:
                                    provider.uid == widget.comment![index]["uid"]
                                        ? TextAlign.end
                                        : TextAlign.start,
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Visibility(
                                visible: provider.uid == widget.comment![index]["uid"],
                                child: CircleAvatar(
                                  child: AvatarImageHolder(
                                    url: widget.comment![index]["image"],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: Row(
                                mainAxisAlignment:provider.uid == widget.comment![index]["uid"]? MainAxisAlignment.end:MainAxisAlignment.start,
                                children: [
                                  Text(getTimeDifferenceFromNow(d.toDate()) , style: TextStyle(fontSize: 8)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
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
                  onPressed: () {
                    var user =
                        Provider.of<UserProvider>(context, listen: false);
                    context.read<PostProvider>().commentOnPost(
                        context,
                        widget.docId,
                        user.uid,
                        commentController.text,
                        user.displayName,
                        user.photoUrl);
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
  }
}

var a = 0;
