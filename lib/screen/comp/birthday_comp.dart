import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/util/widget.dart';

import '../../provider/all_user_provider.dart';

class BirthDayComp extends StatefulWidget {
  const BirthDayComp({Key? key}) : super(key: key);

  @override
  State<BirthDayComp> createState() => _BirthDayCompState();
}

class _BirthDayCompState extends State<BirthDayComp> {
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Consumer<AllUserProvider>(
      builder: (context, dob, child) {
        return Visibility(
            visible: dob.listDobUser.isNotEmpty,
            child: Container(
              height: s.height * .2,
              color: Colors.grey,
              child: ListView.builder(
                itemCount: dob.listDobUser.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: s.width,
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                    width: s.width * .35,
                                    height: s.width * .4,
                                    child: AvatarImageHolder(
                                      url: dob.listDobUser[index]["image"],
                                    )),
                              ),
                              Text("${dob.listDobUser[index]["name"]}"),
                              SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                          Expanded(
                              child: Container(
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Wish ${dob.listDobUser[index]["name"]}"),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.cake,
                                      color: Colors.purple,
                                    ))
                              ],
                            )),
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
      },
    );
  }
}
