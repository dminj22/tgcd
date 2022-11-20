import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/post_provider.dart';
import 'package:tgcd/provider/user_provider.dart';

import 'comment_page.dart';

enum Like { like, happy, angry, confuse }

class ReactOnPostComp extends StatefulWidget {
  final docId;
  final toFcmToken;
  final int? likeCount;
  final bool? liked;
  final List? comment;

  const ReactOnPostComp(
      {Key? key,
      this.docId,
      this.liked,
      this.likeCount,
      this.comment,
      this.toFcmToken})
      : super(key: key);

  @override
  State<ReactOnPostComp> createState() => _ReactOnPostCompState();
}

class _ReactOnPostCompState extends State<ReactOnPostComp> {
  String initialEmoji = "";
  var commentController = TextEditingController();

  showCommentBox() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        enableDrag: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                child: CommentPage(
                  docId: widget.docId,
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () {
                      var user =
                          Provider.of<UserProvider>(context, listen: false);
                      if (widget.liked == true) {
                        context
                            .read<PostProvider>()
                            .removeLike(widget.docId, user.uid);
                      } else {
                        var docId = widget.docId;
                        var uid = user.uid;
                        var sendTo = widget.toFcmToken;
                        var name = user.displayName;
                        context
                            .read<PostProvider>()
                            .postLike(docId, uid, sendTo, name);
                      }
                    },
                    icon: widget.liked == true
                        ? Icon(
                            Icons.thumb_up,
                            color: Colors.black,
                            size: 15,
                          )
                        : Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.black,
                            size: 15,
                          ),
                    label: Text(
                      widget.likeCount.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    )),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentPage(
                                  docId: widget.docId,
                                )));
                  },
                  label: Text(
                    "comment",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  icon: Icon(
                    Icons.messenger_outline_rounded,
                    color: Colors.black,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
