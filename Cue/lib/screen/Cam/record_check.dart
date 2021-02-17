import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:Cue/services/video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player_controls/data/controller.dart';
import 'package:video_player_controls/video_player_controls.dart';

class RecordCheckPage extends StatefulWidget {
  final Video originalVideo;
  final String recordVideo;
  RecordCheckPage(
      {Key key, @required this.originalVideo, @required this.recordVideo})
      : super(key: key);

  @override
  _RecordCheckPageState createState() {
    return _RecordCheckPageState();
  }
}

class _RecordCheckPageState extends State<RecordCheckPage> {
  VideoPlayerController videocontroller;
  VideoPlayerController recordcontroller;

  Controller controller;
  Future<void> _initializeVideoPlayerFuture;
  String videoPath;

  int selectedCameraIdx;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool _videoplay = false;
  bool _scriptplay = false;

  @override
  void initState() {
    videocontroller =
        VideoPlayerController.network(widget.originalVideo.videoURL);
    recordcontroller = VideoPlayerController.network(widget.recordVideo);
    _initializeVideoPlayerFuture = videocontroller.initialize();
    videocontroller.setLooping(true);
    // Screen.keepOn(true);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();

    controller = new Controller(
      items: [
        PlayerItem(title: widget.originalVideo.title, url: widget.recordVideo),
      ],
      autoPlay: true,
      errorBuilder: (context, message) {
        return new Container(
          child: new Text(message),
        );
      },
      autoInitialize: true,
      hasSubtitles: true,
      showSkipButtons: false,
      allowFullScreen: true,
      fullScreenByDefault: false,
      // placeholder: new Container(
      //   color: Colors.grey,
      // ),
    );
  }

  @override
  void dispose() {
    recordcontroller?.pause(); // mute instantly
    recordcontroller?.dispose();
    recordcontroller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    _videoplay == true
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: videocontroller.value.initialized
                                ? AspectRatio(
                                    aspectRatio:
                                        videocontroller.value.aspectRatio,
                                    child: VideoPlayer(videocontroller),
                                  )
                                : Container(),
                          )
                        : Container(),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        child: VideoPlayerControls(
                          controller: controller,
                        ),
                      ),
                    ),
                    Container(
                      //padding: const EdgeInsets.fromLTRB(20, 0,0,0),
                      child: Column(
                        children: [
                          _videoplay == false
                              ? RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange)),
                                  onPressed: () {
                                    setState(() {
                                      _videoplay = true;
                                    });
                                  },
                                  color: Colors.white,
                                  textColor: Colors.orange,
                                  child: Text("영상 OFF",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                )
                              : RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)),
                                  onPressed: () {
                                    setState(() {
                                      _videoplay = false;
                                    });
                                  },
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  child: Text("영상 ON",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ]));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget showScript(BuildContext context, var script) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: script.keys.length ~/ 2,
        itemBuilder: (context, int index) {
          String aKey = script.keys.elementAt(index * 2);
          String sKey = script.keys.elementAt(index * 2 + 1);
          return ListTile(
            title: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${script[aKey]}",
                    style: TextStyle(color: Colors.white60)),
                Text("${script[sKey].replaceAll('\\n', '\n')}",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 100),
              ],
            )),
          );
        },
      ),
    );
  }
}
