import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SignupPage extends StatelessWidget{

  final String signupLink = 'https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/signup';

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<http.Response> signupUser() {
    return http.post(
      Uri.parse('https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstnameController.text,
        'lastName' : lastnameController.text,
        'email' : emailController.text,
        'password' : passwordController.text,
        'confirmPassword' : passwordConfirmController.text,
        'title' : '',
      }),
    );
  }

  void saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstnameController.text);
    await prefs.setString('lastName', lastnameController.text);
    await prefs.setString('email', emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightTeal,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to\nDigital Link Card', style: GoogleFonts.raleway(fontSize: 36,), textAlign: TextAlign.center,),
                SizedBox(height: 80,),
                Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    controller: firstnameController,
                  ),
                ),
                Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(fontSize: 24)
                    ),
                    controller: lastnameController,
                  ),
                ),
                Container(
                  width: 240,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 24)
                    ),
                    controller: emailController,
                  ),
                ),
                Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 24)
                    ),
                    controller: passwordController,
                  ),
                ),
                Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(fontSize: 24)
                    ),
                    controller: passwordConfirmController,
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: (){
                      signupUser();
                      saveUserCredentials();
                      Navigator.pushNamed(context, '/userinfo');
                    },
                    child: Text('Sign up', style: TextStyle(fontSize: 24),),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}