import 'dart:io';

import 'package:Cue/screen/video/playlist_page.dart';
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
                child: Row(
                  children: [
                    TextButton(child: Text('취소', style:TextStyle(color: Colors.white),), onPressed:() {
                      Navigator.pop(context);
                    },),
                    Spacer(),
                    TextButton(child: Text('업로드', style:TextStyle(color: Colors.white),), onPressed:() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => PlayListPage()));
                    },),
                  ],
                )
              ),
              Container(
                height: mh * 0.35,
                width: mw,
                color: Colors.grey,// video insert
              ),
              Padding(
                padding: EdgeInsets.only(left: mw * 0.02, top: mh * 0.025),
                child: Container(
                  height: mh * 0.05,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: new InputDecoration.collapsed(
                          hintText: '제목 입력'
                    ),
                  ),
                ),
              ),
              Divider(color:Colors.white), // TODO 색깔
              Padding(
                padding: EdgeInsets.only(left: mw * 0.02, top: mh * 0.025),
                child: Container(
                  height: mh * 0.15,
                  child: TextFormField(
                    controller: _expController,
                    decoration: new InputDecoration.collapsed(
                        hintText: '내용 입력'
                    ),
                  ),
                ),
              ),
              Divider(color:Colors.white), // TODO 색깔
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('업로드 설정', style: TextStyle(color: Colors.white,fontSize: 13),),
                    SizedBox(height: mh*0.03),
                    Container(
                      child: Row(
                        children: [
                          Text('공개범위',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Spacer(),
                          ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: public == true ? Colors.white : Colors.grey, // background
                                  onPrimary: Colors.black, // foreground
                                ),
                                child:Center( child:Text('공개')),
                                onPressed: (){ setState(() {
                                  public == true ? public = false : public = true;
                                });},
                          ),
                          ElevatedButton(
                            //width: mw*0.09, height: mh*0.03,
                            style: ElevatedButton.styleFrom(
                              primary: public == false ? Colors.white : Colors.grey, // background
                              onPrimary: Colors.black, // foreground
                            ),
                            child:Center( child:Text('비공개')),
                            onPressed: (){setState(() {
                              public == true ? public = false : public = true;
                            });},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('같이하기 활성화',style: TextStyle(color: Colors.white,fontSize: 16),),
                          Spacer(),
                          TextButton(
                            child: Text(participation == true? '켬' : '끔', style: TextStyle(color: Colors.white),),
                            onPressed: (){setState(() {
                              participation == true ? participation = false : participation = true;
                            });}
                          ),
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