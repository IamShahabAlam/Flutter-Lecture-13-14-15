import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; 
import 'package:path/path.dart' as path;


class editDialog extends StatefulWidget {
  final Map data;
  editDialog({this.data});

  @override
  _editDialogState createState() => _editDialogState();
}

class _editDialogState extends State<editDialog> {
    String imagePath;
      TextEditingController captionController = TextEditingController();

  @override

  void initState(){
       super.initState();
        
        captionController.text = widget.data["Caption"];
     }


   Widget build(BuildContext context) {
 
    void pickImage() async{
  final ImagePicker _picker = ImagePicker(); 
  final image = await _picker.getImage(source: ImageSource.gallery);
  print( image.path);

  setState(() {
      imagePath = image.path;
    });
 }

    void done() async{
      try {
        String imageName = path.basename(imagePath);

    firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref =
  firebase_storage.FirebaseStorage.instance.ref('/$imageName');
    
    // putting data in FireBase
    File file = File(imagePath);
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    FirebaseFirestore db = FirebaseFirestore.instance;
   
   
    Map<String, dynamic> newPost = {
      "Caption" : captionController.text,
      "Image Link" : downloadURL,
    };
    await db.collection("Posts").doc(widget.data["id"]).set(newPost);
    
    Navigator.pop(context);
    print("**** Post is Successfully Updated ****");
    

        
      } catch (e) {
        print("******** ERROR ********");
        print(e);
      }
    }


    return AlertDialog(
      content: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
           Container( height: 35, width: MediaQuery.of(context).size.width/1.2 , padding: EdgeInsets.only(left: 7),
                    child: TextField( 
                      controller: captionController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle( 
                              color: Colors.black,
                              fontSize: 15
                            ),
                            hintText: ("What's on your mind?"),
                            contentPadding: EdgeInsets.all(10),
                            
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey) , borderRadius: BorderRadius.circular(30))
                            ),
                        ),
                  ),

                  ElevatedButton(
                              onPressed: pickImage, child: Text("Select Image")
                              ),
                         
                         ElevatedButton(onPressed: done, child: Text("Post")),
      ],),
      
    );
  }
}