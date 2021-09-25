import 'package:digital_link_card/card_information.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class UserInformationPage extends StatelessWidget {

  final titleController = TextEditingController();

  void saveUserTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('title', titleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('What is your job title?', style: Constants.heading2BlackTextStyle,),
              Text('It can also be your occupation or interest.\nFor example: Fullstack Developer or Computer Science', style: Constants.bodySmallBlackTextStyle,),
              Container(
                width: 240,
                child: TextField(
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                      labelText: 'Job Title',
                      labelStyle: Constants.bodyBigBlackTextStyle
                  ),
                  controller: titleController,
                ),
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    saveUserTitle();
                    Navigator.pushNamed(context, '/socialmedia');
                  },
                  child: Text('Next'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}