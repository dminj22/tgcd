import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tgcd/util/widget.dart';
import 'add_name_screen.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({Key? key}) : super(key: key);

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  Future<List<String>>? avatar;
  List path = [];
  var _selectImage;
  var _selectPath;

  getImage() async {
    final storageRef = FirebaseStorage.instance.ref().child("avatar");
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {}
    List<String> a = [];
    List<String> _path = [];
    for (var item in listResult.items) {
      a.add(await item.getDownloadURL());
      _path.add(item.fullPath);
    }
    print(a);
    avatar = Future.value(a);
    path = _path;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Select Avatar"),
            Expanded(
              child: FutureBuilder(
                  future: avatar,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                _selectImage = snapshot.data[index];
                                _selectPath = path[index];
                                print(_selectPath);
                              },
                              child: AvatarImageHolder(
                                url: snapshot.data[index],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return Center(
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator()));
                    }
                  }),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                    backgroundColor: MaterialStateProperty.all(Colors.purple),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)))),
                onPressed: () {
                  if (_selectImage != null)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNameScreen(
                                  url: _selectImage,
                                  path: _selectPath,
                                )));
                },
                child: Text("Next"))
          ],
        ),
      ),
    );
  }
}
