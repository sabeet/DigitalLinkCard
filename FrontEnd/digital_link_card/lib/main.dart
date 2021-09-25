import 'package:digital_link_card/card_information.dart';
import 'package:digital_link_card/user_information_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'theme.dart';

// Pages import
import 'signup_page.dart';
import 'user_information_page.dart';
import 'social_media_page.dart';
import 'user_card_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Constants.lightTeal,
        scaffoldBackgroundColor: Constants.lightTeal,
        fontFamily: 'ArchitectsDaughter',
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonThemeDLC.elevatedButtonStyle),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/signup': (context) => SignupPage(),
        '/userinfo' : (context) => UserInformationPage(),
        '/socialmedia' : (context) => SocialMediaPage(),
        '/main': (context) => UserCardPage(),
      },
      // home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Welcome to\nDigital Link Card', style: GoogleFonts.raleway(fontSize: 36,), textAlign: TextAlign.center,),
              Container(
                // height: 200,
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('Sign up'),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/main');
                        },
                        child: Text('Log in'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}