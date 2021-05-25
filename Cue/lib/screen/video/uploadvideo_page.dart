import 'dart:io';

import 'package:Cue/screen/main_page.dart';
import 'package:Cue/services/auth_provider.dart';
import 'package:Cue/services/database.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:neeko/neeko.dart';
import 'package:provider/provider.dart';

class UploadVideoPage extends StatefulWidget {
  final ReferenceVideo originalVideo;
  final String uploadedURL;
  UploadVideoPage(
      {Key key, @required this.originalVideo, @required this.uploadedURL})
      : super(key: key);
  @override
  UploadVideoPageState createState() {
    return UploadVideoPageState();
  }
}

class UploadVideoPageState extends State<UploadVideoPage> {
  VideoControllerWrapper videoControllerWrapper;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  File _image;
  String title = '';
  bool _public = true;
  bool _join = true;
  bool _loading = false;

  @override
  void initState() {
    videoControllerWrapper = VideoControllerWrapper(
        DataSource.network(widget.uploadedURL, displayName: '새로운 연기'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);

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
                  child: Row(
                children: [
                  TextButton(
                    child: Text(
                      '취소',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // 취소하면 storage에 올린 것 지우기.
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  TextButton(
                    child: Text(
                      '업로드',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await db.uploadUserVideo(
                          _titleController.text.trim(),
                          _descriptionController.text,
                          _public,
                          _join,
                          widget.originalVideo,
                          widget.uploadedURL);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MainPage()));
                    },
                  ),
                ],
              )),
              Container(
                height: mh * 0.35,
                width: mw,
                child: NeekoPlayerWidget(
                  videoControllerWrapper: videoControllerWrapper,
                  progressBarHandleColor: Theme.of(context).accentColor,
                  progressBarPlayedColor: Theme.of(context).accentColor,
                  onPortraitBackTap: () {
                    Navigator.pop(context);
                  },
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print("share");
                        })
                  ],
                ), // video insert
              ),
              Padding(
                padding: EdgeInsets.only(left: mw * 0.03, top: mh * 0.025),
                child: Container(
                  height: mh * 0.05,
                  child: TextFormField(
                    controller: _titleController,
                    decoration:
                        new InputDecoration.collapsed(hintText: '제목 입력'),
                  ),
                ),
              ),
              Divider(color: Colors.white), // TODO 색깔
              Padding(
                padding: EdgeInsets.only(left: mw * 0.03, top: mh * 0.025),
                child: Container(
                  height: mh * 0.15,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration:
                        new InputDecoration.collapsed(hintText: '내용 입력'),
                  ),
                ),
              ),
              Divider(color: Colors.white), // TODO 색깔
              SizedBox(height: mh * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: mw * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '업로드 설정',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(height: mh * 0.03),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            '공개범위',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _public == true
                                  ? Colors.white
                                  : Colors.grey, // background
                              onPrimary: Colors.black, // foreground
                            ),
                            child: Center(child: Text('공개')),
                            onPressed: () {
                              setState(() {
                                _public == true
                                    ? _public = false
                                    : _public = true;
                              });
                            },
                          ),
                          ElevatedButton(
                            //width: mw*0.09, height: mh*0.03,
                            style: ElevatedButton.styleFrom(
                              primary: _public == false
                                  ? Colors.white
                                  : Colors.grey, // background
                              onPrimary: Colors.black, // foreground
                            ),
                            child: Center(child: Text('비공개')),
                            onPressed: () {
                              setState(() {
                                _public == true
                                    ? _public = false
                                    : _public = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            '같이하기 활성화',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Spacer(),
                          TextButton(
                              child: Text(
                                _join == true ? '켬' : '끔',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _join == true ? _join = false : _join = true;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
