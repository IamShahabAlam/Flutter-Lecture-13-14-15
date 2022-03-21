import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lect013/login.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void Register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      // print("Username:" + username);
      // print("email:" + email);
      // print("password" + password);

      try {
        // it tries this if it doesnt work then catch statment displays
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await db.collection("users").doc(user.user.uid).set({
          "email": email,
          "username": username,
        });

        print("User is Registered");
      } catch (e) {
        print("ERROR");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: Icon(Icons.arrow_back_ios),
        title: Center(child: Text("Registration")),
        actions: [
          FlatButton(
              color: Colors.blueGrey,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Icon(Icons.login_sharp))
        ],
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
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(),
                      labelText: ("Username"),
                      hintText: ("Enter Username")),
                ),
              ),
            ),
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
              child:
                  ElevatedButton(onPressed: Register, child: Text("Sign up")),
            )
          ],
        ),
      )),
    );
  }
}
