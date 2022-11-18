import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../../util/widget.dart';

class CommentPage extends StatefulWidget {
  final List? comment;

  const CommentPage({Key? key, this.comment}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.comment!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              child: AvatarImageHolder(
                url: widget.comment![index]["image"],
              ),
            ),
            title: Text(
              "${widget.comment![index]["comment"]}",
              style: TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
