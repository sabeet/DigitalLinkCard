import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'card_model.dart';
import 'social_media.dart';
import 'card_information.dart';

import 'dart:convert';
import 'constants.dart';

class OtherCardPage extends StatefulWidget {
  @override
  _OtherCardPageState createState() => _OtherCardPageState();
}

class _OtherCardPageState extends State<OtherCardPage> {
  final String getUserAPI = 'https://us-central1-digitallinkcard-687db.cloudfunctions.net/api/getuser?email=';

  final otherEmailController = TextEditingController();

  late SocialMediaLinks socMedLinks;

  Future<Map<String, dynamic>> getUserInfo() async {
    String userEndpoint = getUserAPI + otherEmailController.text;

    final response = await http.get(
        Uri.parse(userEndpoint)
    );

    return jsonDecode(response.body);
  }

  CardInformation? cardInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (cardInfo == null) ?
              Text('Other\'s Card', style: Constants.heading1BlackTextStyle,)
              : Text('${cardInfo!.firstname}\'s Card', style: Constants.heading1BlackTextStyle,),

              if(cardInfo != null) DigitalCard(cardInfo: cardInfo!, socMedLinks: socMedLinks,),



              Container(
                width: 240,
                child: TextField(
                  style: TextStyle(fontSize: 24),
                  decoration: InputDecoration(
                    labelText: 'Other\'s Email',
                    labelStyle: TextStyle(fontSize: 24),
                  ),
                  controller: otherEmailController,
                ),
              ),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {

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
                    socMedLinks = SocialMediaLinks(socMedKey, socMedValue);

                    setState(() {
                      cardInfo = CardInformation(firstname: userMap['firstName'], lastname: userMap['lastName'], title: userMap['title'], email: userMap['email']);
                    });


                  },
                  child: Text('Get Card'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalCard extends StatelessWidget {
  late final CardInformation cardInfo;
  late final SocialMediaLinks socMedLinks;

  DigitalCard({
    required this.cardInfo,
    required this.socMedLinks,
  });

  @override
  Widget build(BuildContext context){
    return FlipCard(
      front: FrontCard(cardInfo: cardInfo,),
      back: BackCard(socMedLinks: socMedLinks),
      direction: FlipDirection.VERTICAL,
    );
  }
}

class FrontCard extends StatelessWidget{
  late final CardInformation cardInfo;



  FrontCard({
    required this.cardInfo,
  });

  @override
  Widget build(BuildContext context) {
    return CardModelFront(type: 1, cardInfo: cardInfo,);
  }
}

class BackCard extends StatelessWidget{
  final socMedLinks;
  BackCard({
    required this.socMedLinks
  });

  @override
  Widget build(BuildContext context) {
    // final SocialMediaLinks socMedLinks = ModalRoute.of(context)!.settings.arguments as SocialMediaLinks;
    return CardModelBack(type: 1, socMedLinks: socMedLinks);

  }
}