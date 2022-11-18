import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/util/widget.dart';

class AddNameScreen extends StatefulWidget {
  final url;
  final path;

  const AddNameScreen({Key? key, this.url, this.path}) : super(key: key);

  @override
  State<AddNameScreen> createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> {
  var _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: AvatarImageHolder(
              url: widget.url,
            )),
            Expanded(
                child: Card(
                    child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        label: Text("Full Name"),
                        contentPadding: EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<UserProvider>().updateUserProfile(
                          context, _nameController.text, widget.path);
                    },
                    child: Text("Submit"))
              ],
            )))
          ],
        ),
      ),
    );
  }
}
