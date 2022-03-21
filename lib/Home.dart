

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lect013/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage; 
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    TextEditingController captionController = TextEditingController();
    String imagePath;

  Stream postsStream =
      FirebaseFirestore.instance.collection('Posts').snapshots();

  @override
  Widget build(BuildContext context) {


    void pickImage() async{
  final ImagePicker _picker = ImagePicker(); 
  final image = await _picker.getImage(source: ImageSource.gallery);
  print( image.path);

  setState(() {
      imagePath = image.path;
    });
 }

  void submit() async{
    try {
      String caption = captionController.text; 
      String imageName = path.basename(imagePath);

    firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref =
  firebase_storage.FirebaseStorage.instance.ref('/$imageName');
    print("caption :" + caption);
    
    File file = File(imagePath);
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Posts").add({
          "Caption": caption,
          "Image Link": downloadURL,
        });
     
    print("caption :" + caption);
        

    print("****Post Uploaded Successfully*****");
    print(downloadURL);
    captionController.clear();
    } 
    catch (e) {
      print(e.message);   // prints error in cmd
    }

    String caption = captionController.text; 

    firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;

  firebase_storage.Reference ref =
  firebase_storage.FirebaseStorage.instance.ref('/image.jpeg');
    

    
  }


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.blue[400],
        leadingWidth: 130,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12, left: 8),
          child: Text(
            "facebook",
            style: TextStyle(
                color: Colors.blue, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        
        actions: [
          SizedBox( height:35, width: 35, 
            child: ElevatedButton(style: ElevatedButton.styleFrom( 
            primary: Colors.grey[200] , onPrimary: Colors.black, 
            shape: CircleBorder(), 
            padding: EdgeInsets.all(5)
        ),
            onPressed: () {}, child:Icon(FontAwesomeIcons.search, size: 18,)),
          ),
        

          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 10),
            child: SizedBox( height: 35, width: 35, 
              child: ElevatedButton( style: ElevatedButton.styleFrom(
                onPrimary: Colors.black,
                primary: Colors.grey[200],
                shape: CircleBorder(),
                padding: EdgeInsets.all(5),
                
              ),
                onPressed: (){}, child: Icon(FontAwesomeIcons.facebookMessenger,size: 20,)),
            ),
          )
          
          
          ],
      ),
     
     
      body: Column(
        children: [
          
              
              ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      CircleAvatar( radius: 23, backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage("https://scontent.fkhi8-1.fna.fbcdn.net/v/t1.6435-9/84183504_105773450980382_7180527463066238976_n.jpg?_nc_cat=106&ccb=1-4&_nc_sid=09cbfe&_nc_eui2=AeHvgexDFLgIP7s1DmWjLklpEhEkfIDqtAcSESR8gOq0BwKblcrH4ofzMl6Q0DiNk2Hi98frbr1duAHSIetMxP7j&_nc_ohc=qtzvT-Z8z8gAX9nX_jf&_nc_ht=scontent.fkhi8-1.fna&oh=d275ead4a8e4918c0c273d16a268e7dc&oe=61329ECC", ),
                      ),

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
                  
                  ],
                  ),

                  Column(
                    children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           ElevatedButton(
                              onPressed: pickImage, child: Text("Select Image")
                              ),
                         
                         ElevatedButton(onPressed: submit, child: Text("Post")),
                         
                         ],
                       ),
                    ],
                  )
                ],
              ),

              
            
            
          
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: postsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Something went wrong');
                    
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return new ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map data = document.data();
                      String id = document.id;
                      data["id"]=id;
                      return Post(data: data);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
