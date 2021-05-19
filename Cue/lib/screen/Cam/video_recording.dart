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
    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
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
        ],
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.flip_camera_android;
      case CameraLensDirection.front:
        return Icons.flip_camera_android;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
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

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection),
                color: Colors.white, size: 30),
//            label: Text(
//                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(100, 0, 0, 100),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.radio_button_checked, size: 70),
                  color: Colors.orange,
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
//                  : null,
              ),
//            IconButton(
//              icon: const Icon(Icons.stop),
//              color: Colors.red,
//              onPressed: controller != null &&
//                  controller.value.isInitialized &&
//                  controller.value.isRecordingVideo
//                  ? _onStopButtonPressed
//                  : null,
//            )
            ],
          ),
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
    selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    });
  }

  void _onStopButtonPressed() {
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });
    // showAlertDialog(context);
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
//      showAlertDialog(context);
      addUser();
      Fluttertoast.showToast(
          msg: 'Video recorded to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    });
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

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
      _showCameraException(e);
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
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
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
