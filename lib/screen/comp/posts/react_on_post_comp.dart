import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/post_provider.dart';
import 'package:tgcd/provider/user_provider.dart';

import 'comment_page.dart';

enum Like { like, happy, angry, confuse }

class ReactOnPostComp extends StatefulWidget {
  final docId;
  final int? likeCount;
  final bool? liked;
  final List? comment;

  const ReactOnPostComp({Key? key, this.docId, this.liked, this.likeCount, this.comment})
      : super(key: key);

  @override
  State<ReactOnPostComp> createState() => _ReactOnPostCompState();
}

class _ReactOnPostCompState extends State<ReactOnPostComp> {
  String initialEmoji = "";
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(thickness: 1,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    onPressed: () {
                      var user = Provider.of<UserProvider>(context, listen: false);
                      if (widget.liked == true) {
                        context
                            .read<PostProvider>()
                            .removeLike(widget.docId, user.uid);
                      } else {
                        context.read<PostProvider>().postLike(widget.docId, user.uid);
                      }
                    },
                    icon: widget.liked == true
                        ? Icon(Icons.thumb_up , color: Colors.black, size: 15,)
                        : Icon(Icons.thumb_up_alt_outlined , color: Colors.black, size: 15,),
                    label: Text(widget.likeCount.toString() , style: TextStyle(color: Colors.black , fontSize: 12),)),
                TextButton.icon(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentPage(
                            comment: widget.comment,
                          )));
                }, label: Text("comment" , style: TextStyle(color: Colors.black , fontSize: 12),), icon: Icon(Icons.messenger_outline_rounded , color: Colors.black, size: 15,),),
                // Visibility(
                //     visible: commentController.text.length > 5,
                //     child: IconButton(
                //         onPressed: () {
                //           var user =
                //               Provider.of<UserProvider>(context, listen: false);
                //           context.read<PostProvider>().commentOnPost(
                //               widget.docId,
                //               user.uid,
                //               commentController.text,
                //               user.displayName,
                //               user.photoUrl);
                //           commentController.clear();
                //           setState(() {});
                //         },
                //         icon: Icon(Icons.send)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
