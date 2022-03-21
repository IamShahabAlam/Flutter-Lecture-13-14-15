import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(text: "Shahab@gmail.com");
    final TextEditingController passwordController = TextEditingController(text: "qwerty");

    void Login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      final String email = emailController.text;
      final String password = passwordController.text;
      // print("Username:" + username);
      // print("email:" + email);
      // print("password" + password);

      try {// it tries this if it doesnt work then catch statment displays
          final UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
          final DocumentSnapshot snapshot = await db.collection("users").doc(user.user.uid).get();

          final data = snapshot.data();

          print("***** User Successfully Logged In *****");
          // print(data["email"]);
          // print(data["username"]);

           Navigator.of(context).pushNamed("/home" , arguments: data) ; // passing data on next screen
      
      } catch (e) {
        print("***** ERROR *****");
        print(e.message);

        showDialog(context: (context), builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))],

          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: FlatButton(
            textColor: Colors.white,
            onPressed: () {},child: Icon(Icons.arrow_back_ios)),
        title: Center(child: Text("LOGIN")),
        actions: [Icon(Icons.arrow_forward_ios)],
      ),

      //  ==================================================================

      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                height: MediaQuery.of(context).size.height / 9,
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.yellow,
                    fillColor: Colors.blue[50],
                    filled: true,
                    labelText: ("Email"),
                    hintText: ("Enter Email"),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                height: MediaQuery.of(context).size.height / 9,
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  // obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusColor: Colors.yellow,
                    fillColor: Colors.blue[50],
                    filled: true,
                    labelText: ("Password"),
                    hintText: ("Enter Password"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(onPressed: Login, child: Text("Login")),
            )
          ],
        ),
      )),
    );
  }
}
