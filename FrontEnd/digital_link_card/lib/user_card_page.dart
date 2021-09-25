import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'card_information.dart';
import 'card_model.dart';



class UserCardPage extends StatefulWidget{
  @override
  _UserCardPageState createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {
  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<CardInformation> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late CardInformation cardInfo;
    cardInfo = CardInformation(
      firstname: (prefs.getString('firstName') ?? 'Firstname'),
      lastname: (prefs.getString('lastName') ?? 'Lastname'),
      email: (prefs.getString('email') ?? 'empty@email.com'),
      title: (prefs.getString('title') ?? 'Empty Title')
    );
    return cardInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Your Card', style: Constants.heading1BlackTextStyle),
              FutureBuilder(
                future: loadUserInfo(),
                builder: (context, AsyncSnapshot<CardInformation> snapshot) {
                  if(snapshot.hasData){
                    return DigitalCard(cardInfo: snapshot.data!,);
                  }
                  else {
                    return SizedBox();
                  }

                },),
              // DigitalCard(cardInfo: cardInfo,),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalCard extends StatelessWidget {
  late final CardInformation cardInfo;

  DigitalCard({
    required this.cardInfo,
  });

  @override
  Widget build(BuildContext context){
    return FlipCard(
      front: FrontCard(cardInfo: cardInfo,),
      back: BackCard(),
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
  @override
  Widget build(BuildContext context) {
    return CardModelBack(type: 1,);

  }
}