import 'package:flutter/material.dart';
import 'package:lect013/Home.dart';
import 'package:lect013/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lect013/login.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
        return FutureBuilder(
          future: _initialization ,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(child: Text("There is an ERROR !!"),);
            }
            else if (snapshot.connectionState== ConnectionState.done){
              return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter with Firebase',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: Login(),  
      routes: {
        "/login" : (context) => Login(),
        "/register" : (context) => Register(),
        "/home" : (context) => Home(),
        }
     );
            }

        return Container(child: Text("Wait! Loading"));
          } 
          );
}
}


  
  
 