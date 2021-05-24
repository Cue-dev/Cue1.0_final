import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadVideoPage extends StatefulWidget {
  @override
  UploadVideoPageState createState() {
    return UploadVideoPageState();
  }
}

class UploadVideoPageState extends State<UploadVideoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _expController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  File _image;
  String title = '';
  bool public = true;
  bool participation = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: RaisedButton(
                          child: Text("갤러리"),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          mw * 0.012, mh * 0.007, mw * 0.012, mh * 0.007),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return '제목을 입력하세요!';
                          } else
                            return null;
                        },
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: '제목',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          mw * 0.012, mh * 0.007, mw * 0.012, mh * 0.007),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return '설명을 입력하세요!';
                          } else
                            return null;
                        },
                        controller: _expController,
                        decoration: InputDecoration(
                          hintText: '설명',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          mw * 0.036, mh * 0.022, mw * 0.036, mh * 0.022),
                      child: Row(
                        children: <Widget>[
                          Text('공개'),
                          Switch(
                            value: public,
                            onChanged: (value) {
                              setState(() {
                                public == false
                                    ? public = true
                                    : public = false;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                          SizedBox(
                            width: mw * 0.024,
                          ),
                          Text('참여하기'),
                          Switch(
                            value: participation,
                            onChanged: (value) {
                              setState(() {
                                participation == false
                                    ? participation = true
                                    : participation = false;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                          SizedBox(
                            width: mw * 0.12,
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.black,
                              // size: mw * 0.73,
                              size: 30,
                            ),
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                if (!_loading) {

                                }
                              }
                            },
                          ),
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
