import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/util/widget.dart';
import 'package:intl/intl.dart';
import '../provider/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<UserProvider>().getDob());

  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<UserProvider>(
          builder: (context, data, child) {
            return Column(
              children: [
                Hero(
                  tag: "profile",
                  child: Center(
                    child: Container(
                        height: s.height * .4,
                        width: s.width * .7,
                        child: AvatarImageHolder(
                          url: data.photoUrl,
                        )),
                  ),
                ),
                ListTile(
                  title: Text("Name"),
                  trailing: Text("${data.displayName}"),
                ),
                ListTile(
                  title: Text("Phone Number"),
                  trailing: Text("${data.phoneNumber}"),
                ),
                ListTile(
                  title: Text("Date of Birth"),
                  trailing: data.dob != null
                      ? Text("${DateFormat('dd-MMMM-yyyy').format(data.dob!.toDate())}")
                      : IconButton(
                          onPressed: () {
                            data.showDate(context);
                          }, icon: Icon(Icons.date_range)),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
