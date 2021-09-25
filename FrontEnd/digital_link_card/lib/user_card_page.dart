import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:file/file.dart';

import 'constants.dart';
import 'card_information.dart';
import 'card_model.dart';
import 'social_media.dart';

class UserCardPage extends StatefulWidget{
  @override
  _UserCardPageState createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {
  late List<String> socMedKey;
  late List<String> socMedValue;

  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
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
  _saved(File image) async {
    final result = await ImageGallerySaver.saveImage(image.readAsBytesSync());
    print("File Saved to Gallery");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Card', style: Constants.heading1BlackTextStyle),
              FutureBuilder(
                future: loadUserInfo(),
                builder: (context, AsyncSnapshot<CardInformation> snapshot) {
                  if(snapshot.hasData){
                    return DigitalCard(cardInfo: snapshot.data!);
                  }
                  else {
                    return SizedBox();
                  }

                },
              ),
              Text('(Tap to flip)', style: Constants.bodyBigBlackTextStyle,),
              SizedBox(height: 40,),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/other');
                  },
                  child: Text('See Other Card'),
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
  // final socMedLinks;
  @override
  Widget build(BuildContext context) {
    final SocialMediaLinks socMedLinks = ModalRoute.of(context)!.settings.arguments as SocialMediaLinks;
    return CardModelBack(type: 1, socMedLinks: socMedLinks);

  }
}