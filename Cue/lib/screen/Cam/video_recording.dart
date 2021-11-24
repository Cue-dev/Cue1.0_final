import 'dart:async';
import 'dart:io';

import 'package:Cue/screen/dialog/ready_dialog.dart';
import 'package:Cue/screen/dialog/save_script_dialog.dart';
import 'package:Cue/screen/dialog/wait_dialog.dart';
import 'package:Cue/screen/video/uploadvideo_page.dart';
import 'package:Cue/services/loading.dart';
import 'package:camera/camera.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VideoRecordingPage extends StatefulWidget {
  final ReferenceVideo originalVideo;
  VideoRecordingPage({Key? key, required this.originalVideo}) : super(key: key);

  @override
  _VideoRecordingPageState createState() {
    return _VideoRecordingPageState();
  }
}

class _VideoRecordingPageState extends State<VideoRecordingPage> {
  late CameraController controller;
  late VideoPlayerController videoController;
  late String videoPath;
  late String videoRecordUrl;
  late List<CameraDescription> cameras;
  int selectedCameraIdx = 1;

  final _isHours = true;
  bool _videoPlay = false;
  bool _scriptPlay = false;
  bool _scriptFullPlay = false;
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
    videoController =
        VideoPlayerController.network(widget.originalVideo.videoURL!)
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
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
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
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
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
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.1),
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
                                  : ImageIcon(AssetImage('icons/큐_활성.png'),
                                      color: Colors.yellow),
                              onPressed: () {
                                        controller.value.isInitialized &&
                                        !controller.value.isRecordingVideo
                                    ? _onRecordButtonPressed()
                                    : _onStopButtonPressed();
                              }),
                        ),
                      ),
                      Spacer(),
                      _scriptPlay == false
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
                                  _scriptPlay = true;
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
                                  _scriptPlay = false;
                                });
                              },
                            ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      _videoPlay == false
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
                                  _videoPlay = true;
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
                                  _videoPlay = false;
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
          _videoPlay == true
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: videoController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          )
                        : Container(),
                  ),
                )
              : Container(),
          _scriptPlay == true
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.73,
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: GestureDetector(
                    onTap: () {
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
                        child:
                            showScript(context, widget.originalVideo.script)),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (!controller.value.isInitialized) {
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
            StopWatchTimer.getDisplayTime(value!, hours: _isHours);
        return Text(
          displayTime,
          style: TextStyle(color: Colors.white, fontSize: 20),
        );
      },
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    await controller.dispose();
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

  void _onRecordButtonPressed() async {
    showReadyCueDialog(context);

    setState(() {
      cue = true;
      videoController.value.isPlaying
          ? videoController.pause()
          : videoController.play();
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });

    _startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void showReadyCueDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 3000)),
              builder: (context, snapshot) {
// Checks whether the future is resolved, ie the duration is over
                if (snapshot.connectionState == ConnectionState.done)
                  return FutureBuilder(
                      future: Future.delayed(Duration(milliseconds: 1500)),
                      builder: (context, cueSnap) {
                        if (cueSnap.connectionState == ConnectionState.done) {
                          Navigator.pop(context);
                          return Container();
                        } else
                          return Dialog(
                            insetPadding: EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            child: Center(
                              child: Text(
                                'Cue!',
                                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 25),
                              ),
                            ),
                          );
                      });
                else
                  return Dialog(
                    insetPadding: EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Text(
                        'Ready,',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 25),
                      ),
                    ),
                  ); // Return empty container to avoid build errors
              });
        });
  }

  void _onStopButtonPressed() async {
    String uploadedURL = '';
    setState(() {
      cue = false;
      videoController.value.isPlaying
          ? videoController.pause()
          : videoController.play();
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Loading()));

    await _stopVideoRecording().then((_) async {
      if (mounted)
        // setState(() {
        uploadedURL = await addUser();
      // });
    });
    Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UploadVideoPage(
                  originalVideo: widget.originalVideo,
                  uploadedURL: uploadedURL,
                )));
  }

  Future<String> addUser() async {
    //String url;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("userVideos")
        .child(uploadTime);

    firebase_storage.UploadTask uploadTask = ref.putFile(File(videoPath));
    await uploadTask.whenComplete(() async {
      videoRecordUrl = await ref.getDownloadURL();
    });
    // String downloadUrl = await ref.getDownloadURL();
    // final String url = downloadUrl.toString();
    // videoRecordUrl = url;
    return videoRecordUrl;
  }

  Future<String?> _startVideoRecording() async {
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
      await controller.startVideoRecording();
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
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01),
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
                child: Column(children: [
                  Row(children: [
                    Text('전체 대본'),
                    SizedBox(width: mw * 0.3),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ]),
                  showScript(context, script),
                ])));
      },
    );
  } // 전체대본
}
