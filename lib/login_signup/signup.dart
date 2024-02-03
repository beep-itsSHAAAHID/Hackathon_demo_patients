import 'package:blockchain_demo/login_signup/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';




class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Add user details to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
      });

      // Navigate to another screen or perform additional actions after successful signup
      // For example, you can use Navigator to push a new screen:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));

    } catch (e) {
      print("Error during sign up: $e");
      // Handle sign-up errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10),
                  Text("Welcome!", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            buildTextField("Full Name", _fullNameController),
                            buildTextField("Email", _emailController),
                            buildTextField("Phone Number", _phoneNumberController),
                            buildTextField("Password", _passwordController, isPassword: true),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      MaterialButton(
                        onPressed: _signUp,
                        height: 50,
                        color: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}