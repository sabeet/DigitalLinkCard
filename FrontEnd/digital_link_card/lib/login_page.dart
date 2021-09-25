import 'package:digital_link_card/social_media.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginPage extends StatelessWidget {
  final String loginLink = 'https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/login';
  final String getUserAPI = 'https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/getuser?email=';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<http.Response> loginUser() {
    return http.post(
      Uri.parse(loginLink),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email' : emailController.text,
        'password' : passwordController.text,
      }),
    );
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    String userEndpoint = getUserAPI + emailController.text;

    final response = await http.get(
      Uri.parse(userEndpoint)
    );

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login to\nDigital Link Card', style: Constants.heading2BlackTextStyle,),
              SizedBox(height: 40,),
              Container(
                width: 240,
                child: TextField(
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 24),
                  ),
                  controller: emailController,
                ),
              ),
              Container(
                width: 240,
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 24),
                  ),
                  controller: passwordController,
                ),
              ),
              SizedBox(height: 40,),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {

                    final response = await loginUser();
                    Map<String, dynamic> userMap = await getUserInfo();
                    print(userMap);

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('firstName', userMap['firstName']);
                    await prefs.setString('lastName', userMap['lastName']);
                    await prefs.setString('email', userMap['email']);
                    await prefs.setString('title', userMap['title']);

                    print(userMap['links']);
                    Map<String, dynamic> links = userMap['links'];
                    List<String> socMedKey = links.keys.toList();
                    List<String> socMedValue = links.values.toList().cast<String>();


                    print(links);
                    print(socMedKey);
                    print(socMedValue);
                    SocialMediaLinks socMedLinks = SocialMediaLinks(socMedKey, socMedValue);

                    Navigator.pushNamed(context, '/main', arguments: socMedLinks);
                  },
                  child: Text('Log in'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}