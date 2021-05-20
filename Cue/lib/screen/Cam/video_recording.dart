import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:Cue/screen/Cam/record_check.dart';
import 'package:Cue/screen/main_page.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VideoRecordingPage extends StatefulWidget {
  final ReferenceVideo originalVideo;
  VideoRecordingPage({Key key, @required this.originalVideo}) : super(key: key);

  @override
  _VideoRecordingPageState createState() {
    return _VideoRecordingPageState();
  }
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  CameraController controller;
  VideoPlayerController videocontroller;
  String videoPath;
  String videoRecordurl;
  List<CameraDescription> cameras;
  int selectedCameraIdx;

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    // onChange: (value) => print('onChange $value'),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  TextEditingController videoTitleController = TextEditingController();
  final String uploadTime =
  ('${DateTime.now().year.toString()}:${DateTime.now().month.toString()}:${DateTime.now().day.toString()} ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}');

  bool _videoplay = false;
  bool _scriptplay = false;

  @override
  void initState() {
    super.initState();
    videocontroller =
    VideoPlayerController.network(widget.originalVideo.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 37.0),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Center(
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: MediaQuery.of(context).size.width*0.35),
                          Text(displayTime, style: TextStyle(color: Colors.white, fontSize: 20),),
                          Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width*0.2, height:MediaQuery.of(context).size.height*0.05,
                            color:Colors.grey,
                            child:Center(child: Text('박새로이',style: TextStyle(color: Colors.black))), // TODO : 전단계에서 선택한 배역
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child :Text('16:9',style: TextStyle(color: Colors.white)),
                      onPressed: (){},
                    ),
                    TextButton(
                      child :Text('4:3',style: TextStyle(color: Colors.white)),
                      onPressed: (){},
                    ),
                    TextButton(
                      child :Text('1:1',style: TextStyle(color: Colors.white)),
                      onPressed: (){},
                    ),
                    _captureControlRowWidget(),
                    _scriptplay == false
                        ? Container(
                      width: MediaQuery.of(context).size.width*0.15,
                      height: MediaQuery.of(context).size.height*0.04,
                          child: RaisedButton(
                      shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white)),
                      onPressed: () {
                          setState(() {
                            _scriptplay = true;
                          });
                      },
                      color: Colors.transparent,
                      textColor: Colors.white,
                      child: Text("대본"),
                    ),
                        )
                        : Container(
                      width: MediaQuery.of(context).size.width*0.15,
                      height: MediaQuery.of(context).size.height*0.04,
                          child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.white,
                      textColor: Colors.grey,
                      child: Text("대본"),
                      onPressed: () {
                          setState(() {
                            _scriptplay = false;
                          });
                      },
                    ),
                        ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02),
                    _videoplay == false
                              ? Container(
                                width: MediaQuery.of(context).size.width*0.15,
                                height: MediaQuery.of(context).size.height*0.04,
                                child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.white)),
                            onPressed: () {
                                setState(() {
                                  _videoplay = true;
                                });
                            },
                            color: Colors.transparent,
                            textColor: Colors.white,
                            child: Text("영상")
                          ),
                              )
                              : Container(
                                width: MediaQuery.of(context).size.width*0.15,
                                height: MediaQuery.of(context).size.height*0.04,
                                child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.white,
                            textColor: Colors.grey,
                            child: Text("영상"),
                            onPressed: () {
                                setState(() {
                                  _videoplay = false;
                                });
                            },
                          ),
                              ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1)
              ],
            ),
          ),
          _videoplay == true
              ? Padding(
            padding: const EdgeInsets.only(top: 90.0, left: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.15,
              child: videocontroller.value.initialized
                  ? AspectRatio(
                aspectRatio: videocontroller.value.aspectRatio,
                child: VideoPlayer(videocontroller),
              )
                  : Container(),
            ),
          )
              : Container(),
          _scriptplay == true
              ? Padding(
            padding: const EdgeInsets.only(top: 500, left: 10.0),
            child: showScript(context, widget.originalVideo.script),
          )
              : Container(),
        ],
      ),
    );
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _captureControlRowWidget() {
    return IconButton(
                  icon: ImageIcon(
                    AssetImage('icons/큐.png'),
                    size: 50,
                  ),
                  onPressed: () {
                    controller != null &&
                        controller.value.isInitialized &&
                        !controller.value.isRecordingVideo
                        ? _onRecordButtonPressed()
                        : _onStopButtonPressed();
                    //수정 할 것!! start추가 ? :
                    setState(() {
                      videocontroller.value.isPlaying
                          ? videocontroller.pause()
                          : videocontroller.play();
                    });
                  }
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _onRecordButtonPressed() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {}
    });
  }

  void _onStopButtonPressed() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      addUser();
    });
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';
    try {
      await controller.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  Future<void> addUser() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child(uploadTime);

    firebase_storage.UploadTask uploadTask = ref.putFile(File(videoPath));
    String downloadUrl = await ref.getDownloadURL();
    final String url = downloadUrl.toString();
    videoRecordurl = url;
    print('videourl: ' + url);
  }

  Widget showScript(BuildContext context, var script) {
    return Container(
      child: ListView.builder(
        itemCount: script.keys.length ~/ 2,
        itemBuilder: (context, int index) {
          String aKey = script.keys.elementAt(index * 2);
          String sKey = script.keys.elementAt(index * 2 + 1);
          return ListTile(
            title: Container(
              color: Colors.black26,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text("${script[aKey]}",
                          style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(width : MediaQuery.of(context).size.width*0.01),
                    Container(
                      width:  MediaQuery.of(context).size.width*0.6,
                      child: Text("${script[sKey]}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
