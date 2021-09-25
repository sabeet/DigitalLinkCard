import 'package:flutter/material.dart';
import 'card_information.dart';
import 'constants.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'social_media.dart';


class CardModelFront extends StatelessWidget{
  /*
    type 1: space
    type 2: x
    type 3: y
   */
  final int type;
  final CardInformation cardInfo;
  CardModelFront({
    required this.type,
    required this.cardInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 350,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: AssetImage('images/card_space_front_bg.png'),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 20,
          child: Text('${cardInfo.firstname} ${cardInfo.lastname}', style: Constants.bodyBigWhiteTextStyle,)
        ),
        Positioned(
          top: 30,
          left: 20,
          child: Text(cardInfo.title, style: Constants.bodySmallWhiteTextStyle,)
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Text(cardInfo.email, style: Constants.bodySmallWhiteTextStyle,)
        ),
      ]
    );
  }
}

class CardModelBack extends StatelessWidget {
  final int type;
  CardModelBack({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(
            child: Container(
              width: 350,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: AssetImage('images/card_space_back_bg.png'),
                ),
              ),
            ),
          ),
          // Positioned(
          //     top: 10,
          //     left: 20,
          //     child: SocialMedia()
          // ),

        ]
    );
  }
}