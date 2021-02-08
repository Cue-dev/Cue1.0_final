import 'package:flutter/material.dart';
import 'package:Cue/screen/LogIn/forget2_page.dart';

class ForgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: mh * 0.3),
          Center(
            child: Text(
              'New password',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
          SizedBox(height: mh * 0.15),
          email('Your e-mail address', mw, mh),
          SizedBox(height: mh * 0.03),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignPW()));
            },
            child: Text('Send',
                style: TextStyle(fontSize: 17, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget email(String txt, double mw, double mh) {
    return Container(
      width: mw * 0.7,
      height: mh * 0.06,
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black)),
      // margin: EdgeInsets.all(10.0),
      child: Row(children: <Widget>[
        Container(
          width: mw * 0.5,
          child: Text(txt, style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      ]),
    );
  }
}
