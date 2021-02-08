import 'package:flutter/material.dart';

class SignPW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(children: <Widget>[
      SizedBox(height: mh * 0.47),
      Center(
        child: Text(
          'Please sign in with your new password!',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    ]));
  }
}
