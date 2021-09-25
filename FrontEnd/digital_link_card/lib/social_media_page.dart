import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'social_media.dart';

import 'constants.dart';

class SocialMediaPage extends StatefulWidget {
  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  final String linkEndpoint = 'https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/addlinks';

  Future<void> patchUserLinks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? 'empty@email.com');

    print('Email: ' + email);
    final response = await http.patch(
      Uri.parse('https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/addlinks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'links' : socMedMap,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      print('successful');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
    }
  }

  String dropdownValue = 'Discord';
  List<String> socMedKey = List.empty(growable: true);
  List<String> socMedValue = List.empty(growable: true);

  final tagController = TextEditingController();

  void addSocMed(String sm, String tag){
    setState(() {
      socMedKey.add(sm);
      socMedValue.add(tag);
    });
  }

  Map<String, dynamic> get socMedMap => Map.fromIterables(socMedKey, socMedValue);

  void saveUserSocMed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('socMedKey', socMedKey);
    await prefs.setStringList('socMedValue', socMedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Text('Add your Social Media!', style: Constants.heading2BlackTextStyle,),
                    Text('(At least add 1 and at most 5 social medias)', style: Constants.bodySmallBlackTextStyle),
                  ],
                ),
              ),

              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: socMedKey.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaIcon.getIcon(socMedKey[index]),
                          SizedBox(width: 4,),
                          Text('${socMedKey[index]}: ', style: Constants.bodyBigBlackTextStyle,),
                          Text(socMedValue[index], style: Constants.bodyBigBlackTextStyle,)
                        ],
                      ),
                    );
                  }
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 18,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: Constants.socialMediaList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18)),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    height: 80,
                    child: TextField(
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                          labelText: 'Tag',
                          labelStyle: Constants.bodyBigBlackTextStyle
                      ),
                      controller: tagController,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 80,
                    child: ElevatedButton(
                      onPressed: (){
                        addSocMed(dropdownValue, tagController.text);
                      },
                      child: Text('Add'),
                    ),
                  ),
                ]
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    patchUserLinks();
                    saveUserSocMed();

                    SocialMediaLinks socMedLinks = SocialMediaLinks(socMedKey, socMedValue);
                    // SocialMediaLinks socMedLinks = SocialMediaLinks('asadasdafas');
                    print(socMedLinks.socMedKey);

                    Navigator.pushNamed(context, '/main', arguments: socMedLinks);
                  },
                  child: Text('Finish'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}