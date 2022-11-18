import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/screen/comp/posts/react_on_post_comp.dart';
import 'package:tgcd/util/widget.dart';

import '../../../provider/post_provider.dart';

class ShowPostComp extends StatefulWidget {
  const ShowPostComp({Key? key}) : super(key: key);

  @override
  State<ShowPostComp> createState() => _ShowPostCompState();
}

class _ShowPostCompState extends State<ShowPostComp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PostProvider>(
        builder: (context, post, child) {
          return StreamBuilder<QuerySnapshot>(
              stream: post.allPosts,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.size != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder: (BuildContext context, int index) {
                            return PostItem(
                              postData: snapshot.data!.docs[index],
                            );
                          },
                        )
                      : Center(
                          child: Container(
                          child: Text("No Post"),
                        ));
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        },
      ),
    );
  }
}

enum Menu { report, delete }

class PostItem extends StatefulWidget {
  final QueryDocumentSnapshot<Object?>? postData;

  const PostItem({Key? key, this.postData}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    var name = widget.postData!.get("name");
    var image = widget.postData!.get("image");
    var created = widget.postData!.get("created");
    String postText = widget.postData!.get("post_text");
    var postUserUid = widget.postData!.get("uid");
    var postToken = widget.postData!.get("token");
    var docId = widget.postData!.id;
    var reportNo = widget.postData!.get("report");
    var type = widget.postData!.get("type");
    List? likeList = widget.postData!.get("like");
    List? comment = widget.postData!.get("comment");

    Timestamp _t = created;
    DateTime _d = _t.toDate();
    String _selectedMenu = '';
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black26)),
      borderOnForeground: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            dense: true,
            style: ListTileStyle.list,
            enableFeedback: true,
            onTap: () {},
            onLongPress: () {},
            leading: Container(
              width: 48,
              height: 48,
              child: AvatarImageHolder(
                url: image,
              ),
            ),
            title: Text(
              name ?? "",
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Wrap(
              children: [
                Text(
                  "${getTimeDifferenceFromNow(_d)}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
                ),
                Icon(
                  Icons.timeline,
                  size: 10,
                )
              ],
            ),
            contentPadding: EdgeInsets.all(10),
            trailing: PopupMenuButton<Menu>(
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                    if (item.name == "delete") {
                      context.read<PostProvider>().deletePost(context, docId , type , widget.postData!.get("image_path"));
                    } else if (item.name == "report") {
                      context
                          .read<PostProvider>()
                          .addReport(context, docId, reportNo);
                    }
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      if (postUserUid != context.read<UserProvider>().uid)
                        PopupMenuItem<Menu>(
                          value: Menu.report,
                          child: Text('Report'),
                        ),
                      if (postUserUid == context.read<UserProvider>().uid)
                        PopupMenuItem<Menu>(
                          value: Menu.delete,
                          child: Text('Delete'),
                        ),
                    ]),
          ),
          if(type == "image")
            Center(child: Image.network(widget.postData!.get("post_image"))),
          if(postText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14 , vertical: 10),
            child: Text(
              "$postText",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
          ReactOnPostComp(
            docId: docId,
            likeCount: likeList!.length,
            comment: comment,
            toFcmToken: postToken,
            liked: likeList.contains(context.read<UserProvider>().uid),
          ),
        ],
      ),
    );
  }
}
