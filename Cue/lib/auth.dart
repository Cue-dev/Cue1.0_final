import 'dart:async';

import 'package:Cue/screen/LogIn/login_page.dart';
import 'package:Cue/screen/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: mh * 0.23,
          ),
          Row(
            children: [
              SizedBox(width: mw * 0.1),
              Image.asset('images/cueLogo1.png'),
            ],
          ),
          SizedBox(
            height: mh * 0.57,
          ),
          Text(
            'ⓒ 2020. Cue Team all rights reserved',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      print(firebaseUser.uid);
      //Means that the user is logged in already and hence navigate to HomePage
      return MainPage();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return LogInPage();
  }
}
