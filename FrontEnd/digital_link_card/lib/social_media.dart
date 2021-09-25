import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart.collection';

import 'constants.dart';

class SocialMediaLinks {
  final List<String> socMedKey;
  final List<String> socMedValue;

  SocialMediaLinks(
    this.socMedKey,
    this.socMedValue
  );
}

class SocialMediaIcon {
  //facebook
  //instagram
  //discord
  //linkedIn
  //snapchat
  //tiktok
  //github
  //reddit
  //youtube
  //twitter
  static FaIcon getIcon(String sm){
    switch(sm){
      case 'Facebook': {
        return FaIcon(FontAwesomeIcons.facebook, color: Colors.blue,);
      }
      case 'Discord': {
        return FaIcon(FontAwesomeIcons.discord, color: Colors.indigo,);
      }
      case 'LinkedIn':{
        return FaIcon(FontAwesomeIcons.linkedin , color: Colors.blue,);
      }
      case 'Snapchat':{
        return FaIcon(FontAwesomeIcons.snapchat , color: Colors.yellow , );
      }
      case 'TikTok':{
        return FaIcon(FontAwesomeIcons.tiktok , color: Colors.black , );
      }
      case 'GitHub':{
        return FaIcon(FontAwesomeIcons.github , color: Colors.grey , );
      }
      case 'Reddit':{
        return FaIcon(FontAwesomeIcons.reddit , color: Colors.red , );
      }
      case 'YouTube':{
        return FaIcon(FontAwesomeIcons.youtube , color: Colors.red , );
      }
      case 'Twitter':{
        return FaIcon(FontAwesomeIcons.twitter , color: Colors.blue , );
      }
      case 'Instagram':{
        return FaIcon(FontAwesomeIcons.instagram , color: Colors.red , );
      }
      default: {
        return FaIcon(FontAwesomeIcons.circle);
      }
    }
  }
}