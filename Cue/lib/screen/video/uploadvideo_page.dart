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
                child: Row(
                  children: [
                    TextButton(child: Text('취소', style:TextStyle(color: Colors.white),), onPressed:() {
                      Navigator.pop(context);
                    },),
                    Spacer(),
                    TextButton(child: Text('업로드', style:TextStyle(color: Colors.white),), onPressed:() {},),
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
                    Text('업로드 설정', style: TextStyle(color: Colors.white),),
                    SizedBox(height: mh*0.03),
                    Container(
                      child: Row(
                        children: [
                          Text('공개범위',style: TextStyle(color: Colors.white,fontSize: 18),),
                          Spacer(),
                          Container(
                              width: mw*0.09, height: mh*0.03,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white),
                              child:Center( child:Text('공개',style: TextStyle(color: Colors.black),),)
                          ),
                          Container(
                              width: mw*0.12, height: mh*0.03,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.white),
                              child:Center( child:Text('비공개',style: TextStyle(color: Colors.black),),)
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('같이하기 활성화',style: TextStyle(color: Colors.white,fontSize: 18),),
                          Spacer(),
                          Text('켬',style: TextStyle(color: Colors.white),),
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