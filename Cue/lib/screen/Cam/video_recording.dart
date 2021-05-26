import 'dart:async';
import 'dart:io';

import 'package:Cue/screen/Cam/ready_dialog.dart';
import 'package:Cue/screen/Cam/script_dialog.dart';
import 'package:Cue/screen/video/uploadvideo_page.dart';
import 'package:camera/camera.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
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
  int selectedCameraIdx = 1;

  final _isHours = true;
  bool _videoplay = false;
  bool _scriptplay = false;
  bool _scriptfullplay = false;
  bool cue = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
      // onChange: (value) => print('onChange $value'),
      );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  TextEditingController videoTitleController = TextEditingController();
  final String uploadTime =
      ('${DateTime.now().year.toString()}:${DateTime.now().month.toString()}:${DateTime.now().day.toString()} ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}');

  @override
  void initState() {
    super.initState();
    videocontroller =
        VideoPlayerController.network(widget.originalVideo.videoURL)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      setState(() {
        selectedCameraIdx = 1;
      });

      _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
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
            child: Center(
              child: Container(
                child: _cameraPreviewWidget(),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: Container(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.navigate_before),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25),
                        _recordingTimer(),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                            child: Text(
                              '박새로이',
                              style: TextStyle(color: Colors.black),
                            ),
                          ), // TODO : 배역 받아 넘기기
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                      InkWell(
                          child: Text('16:9',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {}),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                      InkWell(
                          child:
                              Text('4:3', style: TextStyle(color: Colors.grey)),
                          onTap: () {}),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                      InkWell(
                          child:
                              Text('1:1', style: TextStyle(color: Colors.grey)),
                          onTap: () {}),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.07),
                      Container(
                        child: Transform.scale(
                          scale: 3,
                          child: IconButton(
                              icon: cue == false
                                  ? ImageIcon(AssetImage('icons/큐.png'))
                                  : ImageIcon(AssetImage('icons/큐_활성.png'),color: Colors.yellow),
                              onPressed: () {
                                controller != null &&
                                        controller.value.isInitialized &&
                                        !controller.value.isRecordingVideo
                                    ? _onRecordButtonPressed()
                                    : _onStopButtonPressed();
                                setState(() {
                                  videocontroller.value.isPlaying
                                      ? videocontroller.pause()
                                      : videocontroller.play();
                                });
                              }),
                        ),
                      ),
                      Spacer(),
                      _scriptplay == false
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  side: BorderSide(color: Colors.white)),
                              child: Text(
                                '대본',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _scriptplay = true;
                                });
                              },
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: Text(
                                '대본',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                setState(() {
                                  _scriptplay = false;
                                });
                              },
                            ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      _videoplay == false
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  side: BorderSide(color: Colors.white)),
                              child: Text(
                                '영상',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoplay = true;
                                });
                              },
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: Text(
                                '영상',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoplay = false;
                                });
                              },
                            ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _videoplay == true
              ? Padding(
                  padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.1, left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: MediaQuery.of(context).size.height * 0.13,
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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.73, left:MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.02),
                  child: GestureDetector(
                    onTap: (){
//                      showDialog(
//                        context: context,
//                        builder: (_) {
//                          return ScriptDialog();
//                        }); //TODO : 대본 전체 보여주기
                      },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black26),
                        child: showScript(context, widget.originalVideo.script)),
                  ),
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

  Widget _recordingTimer() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: _stopWatchTimer.rawTime.value,
      builder: (context, snap) {
        final value = snap.data;
        final displayTime =
            StopWatchTimer.getDisplayTime(value, hours: _isHours);
        return Text(
          displayTime,
          style: TextStyle(color: Colors.white, fontSize: 20),
        );
      },
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }
  }

  void _onRecordButtonPressed() {
    setState(() {
      cue = true;
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {}
    });
  }

  void _onStopButtonPressed() async {
    String uploadedURL = '';
    setState(() {
      cue = false;
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });

    await _stopVideoRecording().then((_) async {
      if (mounted)
        // setState(() {
        uploadedURL = await addUser();
      // });
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UploadVideoPage(
              originalVideo: widget.originalVideo,
              uploadedURL: uploadedURL,
            ))); ///TODO : 너무 느림,,,
  }

  Future<String> addUser() async {
    String url;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("userVideos")
        .child(uploadTime);

    firebase_storage.UploadTask uploadTask = ref.putFile(File(videoPath));
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    });
    // String downloadUrl = await ref.getDownloadURL();
    // final String url = downloadUrl.toString();
    // videoRecordurl = url;
    return url;
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

  Widget showScript(BuildContext context, var script) {
    return ListView.builder(
      itemCount: script.keys.length ~/ 2,
      itemBuilder: (context, int index) {
        String aKey = script.keys.elementAt(index * 2);
        String sKey = script.keys.elementAt(index * 2 + 1);
        return ListTile(
          title: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Container(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                      child: Text("${script[aKey]}",
                          style: TextStyle(color: Colors.black, fontSize: 10)),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text("${script[sKey]}",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            )),
          ),
        );
      },
    );
  }

  void _onCueButtonTapped(BuildContext context, var script) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final double mh = MediaQuery.of(context).size.height;
        final double mw = MediaQuery.of(context).size.width;

        return Dialog(
            insetPadding: EdgeInsets.only(top: mh * 0.02),
            child: Padding(
              padding: EdgeInsets.all(mh * 0.015),
              child: Column(
                children: [
                  Row(
              children: [
                Text('전체 대본'),
                SizedBox(width: mw*0.3),
                IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
                },
            )]),
                showScript(context, script),
        ])));
      },
    );
  } // 전체대본
}
