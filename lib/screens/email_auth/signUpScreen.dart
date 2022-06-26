import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirm_passwordController = TextEditingController();

    void createaccount() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String cPassword = confirm_passwordController.text.trim();

      if (email == "" || password == "" || cPassword == "") {
        log('please fill all details');
      }

      if (password != cPassword) {
        log("password doesnt match");
      } else {
        try {
//create new acc in firebase
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          log('user created');

          if (userCredential.user != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Account created successfully!! Now login to continue')));
            Navigator.pop(context);
          }
        } on FirebaseAuthException catch (ex) {
          log(ex.code.toString());
          if (ex.code == 'weak-password') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('entered password is weak')));
          }
          if (ex.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('this email is already registered')));
          }
          if (ex.code == 'invalid-email') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('please enter valid email')));
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Signup Screen')),
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 188, 25, 238),
              Color.fromARGB(255, 47, 94, 159)
            ],
          ),
        ),
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: confirm_passwordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
              ),
              Container(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () {
                        createaccount();
                      },
                      child: Text('Create Account'))),
            ],
          ),
        ),
      ),
    );
  }
}
