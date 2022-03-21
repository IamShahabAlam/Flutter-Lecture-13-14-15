import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'editDialog.dart';

class Post extends StatelessWidget {
  @override
  final Map data;
  Post({this.data});

  Widget build(BuildContext context) {


    void deletePost() async {
      try {
            FirebaseFirestore db = FirebaseFirestore.instance;
            db.collection("Posts").doc(data["id"]).delete();
            print(data["id"]);
            print("*****Post Is Deleted*****");

      } catch (e) {
        print(e.message);
      }
    }


  void editPost() async {
    showDialog(context: context, builder: (BuildContext context){
      return editDialog(data:data);
    });
  }
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 14, left: 15),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(data["Caption"]))),

                    PopupMenuButton( 
                          itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(onPressed: (){ Navigator.pop(context); deletePost();} , child: Text(" Delete"))),
                          PopupMenuItem(child: TextButton(onPressed: (){Navigator.pop(context); editPost();}, child: Text("Edit")))
                        ]),
                      

              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 0.0, bottom: 10),
                child: Image.network(
                  data["Image Link"],
                  width: MediaQuery.of(context).size.width / 1.08,
                  //  height: MediaQuery.of(context).size.height/2,
                )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Container(
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      primary: Colors.white38,
                    ),
                    onPressed: () {},
                    child: Text("Like")),
              ),
              Container(
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      primary: Colors.white38,
                    ),
                    onPressed: () {},
                    child: Text("Comment")),
              ),
              Container(
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      primary: Colors.white38,
                    ),
                    onPressed: () {},
                    child: Text("Share")),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
