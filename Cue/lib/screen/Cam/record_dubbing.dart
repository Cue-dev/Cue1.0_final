// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:Cue/screen/Cam/record_check.dart';
// import 'package:Cue/screen/main_page.dart';
// import 'package:Cue/services/video.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:video_player/video_player.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:Cue/screen/Cam/record_test.dart';

// class DubbingPage extends StatefulWidget {
//   final Video originalVideo;
//   DubbingPage({Key key, @required this.originalVideo}) : super(key: key);

//   @override
//   _DubbingPageState createState() {
//     return _DubbingPageState();
//   }
// }

// class _DubbingPageState extends State<DubbingPage> {
//   VideoPlayerController videocontroller;
//   String videoPath;
//   String recordurl;
//   int selectedCameraIdx;
//   //recoder
//   FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;
//   String _mPath;

//   final _isHours = true;

//   final StopWatchTimer _stopWatchTimer = StopWatchTimer(
//     // onChange: (value) => print('onChange $value'),
//   );

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;
//   TextEditingController videoTitleController = TextEditingController();
//   final String uploadTime =
//   ('${DateTime.now().year.toString()}:${DateTime.now().month.toString()}:${DateTime.now().day.toString()} ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}');

//   @override
//   void initState() {
//     super.initState();
//     videocontroller =
//     VideoPlayerController.network(widget.originalVideo.videoURL)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//     _mPlayer.openAudioSession().then((value) {
//       setState(() {
//         _mPlayerIsInited = true;
//       });
//     });
//     openTheRecorder().then((value) {
//       setState(() {
//         _mRecorderIsInited = true;
//       });
//     });
//     super.initState();
//     // Get the listonNewCameraSelected of available cameras.
//     // Then set the first camera as selected.
//   }
//   @override
//   void dispose() {
// //    stopPlayer();
//     _mPlayer.closeAudioSession();
//     _mPlayer = null;

//     stopRecorder();
//     _mRecorder.closeAudioSession();
//     _mRecorder = null;
//     if (_mPath != null) {
//       var outputFile = File(_mPath);
//       if (outputFile.existsSync()) {
//         outputFile.delete();
//       }
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       key: _scaffoldKey,
//       body:
//       Column(
//         children: [
//           Container(
//             child: videocontroller.value.initialized
//                 ? AspectRatio(
//               aspectRatio: videocontroller.value.aspectRatio,
//               child: VideoPlayer(videocontroller),
//             )
//                 : Container(),
//           ),
//           showScript(context, widget.originalVideo.script),
//           Center(
//             child: StreamBuilder<int>(
//               stream: _stopWatchTimer.rawTime,
//               initialData: _stopWatchTimer.rawTime.value,
//               builder: (context, snap) {
//                 final value = snap.data;
//                 final displayTime =
//                 StopWatchTimer.getDisplayTime(value, hours: _isHours);
//                 return Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Text(
//                         displayTime,
//                         style: TextStyle(
// //                              fontSize: 10,
// //                              fontFamily: 'Helvetica',
// //                              fontWeight: FontWeight.bold
//                             color: Colors.white,
//                             fontSize: 20),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           _captureControlRowWidget(),
//           FlatButton(
//             child: Text('push'),
//             onPressed: (){
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => Demo()));
//             },
//           )
//         ],
//       ),
//     );
//   }

//   /// Display the control bar with buttons to record videos.
//   Widget _captureControlRowWidget() {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               IconButton(
//                   icon: const Icon(Icons.radio_button_checked, size: 70),
//                   color: Colors.orange,
//                   onPressed: () {
//                     getRecorderFn();
// //                    getPlaybackFn();
// //                    controller != null &&
// //                        controller.value.isInitialized &&
// //                        !controller.value.isRecordingVideo
// //                        ? _onRecordButtonPressed()
// //                        : _onStopButtonPressed();
//                     //수정 할 것!! start추가 ? :
//                     setState(() {
//                       videocontroller.value.isPlaying
//                           ? videocontroller.pause()
//                           : videocontroller.play();
//                     });
//                   },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

// //  void _onRecordButtonPressed() {
// //    setState(() {
// //      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
// //    });
// //    _startVideoRecording().then((String filePath) {
// //      if (filePath != null) {
// //        Fluttertoast.showToast(
// //            msg: 'Recording video started',
// //            toastLength: Toast.LENGTH_SHORT,
// //            gravity: ToastGravity.CENTER,
// //            backgroundColor: Colors.grey,
// //            textColor: Colors.white);
// //      }
// //    });
// //  }

// //  void _onStopButtonPressed() {
// //    setState(() {
// //      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
// //    });
// //    showAlertDialog(context);
// //    _stopVideoRecording().then((_) {
// //      if (mounted) setState(() {});
// ////      showAlertDialog(context);
// //      addUser();
// //      Fluttertoast.showToast(
// //          msg: 'Video recorded to $videoPath',
// //          toastLength: Toast.LENGTH_SHORT,
// //          gravity: ToastGravity.CENTER,
// //          backgroundColor: Colors.grey,
// //          textColor: Colors.white);
// //    });
// //  }

// //  Future<String> _startVideoRecording() async {
// //    if (!controller.value.isInitialized) {
// //      Fluttertoast.showToast(
// //          msg: 'Please wait',
// //          toastLength: Toast.LENGTH_SHORT,
// //          gravity: ToastGravity.CENTER,
// //          backgroundColor: Colors.grey,
// //          textColor: Colors.white);
// //
// //      return null;
// //    }
// //
// //    // Do nothing if a recording is on progress
// //    if (controller.value.isRecordingVideo) {
// //      return null;
// //    }
// //
// //    final Directory appDirectory = await getApplicationDocumentsDirectory();
// //    final String videoDirectory = '${appDirectory.path}/Videos';
// //    await Directory(videoDirectory).create(recursive: true);
// //    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
// //    final String filePath = '$videoDirectory/${currentTime}.mp4';
// //    try {
// //      await controller.startVideoRecording(filePath);
// //      videoPath = filePath;
// //    } on CameraException catch (e) {
// //      _showCameraException(e);
// //      return null;
// //    }
// //
// //    return filePath;
// //  }
// //
// //  Future<void> _stopVideoRecording() async {
// //    if (!controller.value.isRecordingVideo) {
// //      return null;
// //    }
// //
// //    try {
// //      await controller.stopVideoRecording();
// //    } on CameraException catch (e) {
// //      _showCameraException(e);
// //      return null;
// //    }
// //  }

//     Future<void> openTheRecorder() async {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }

//       var tempDir = await getTemporaryDirectory();
//       _mPath = '${tempDir.path}/flutter_sound_example.aac';
//       var outputFile = File(_mPath);
//       if (outputFile.existsSync()) {
//         await outputFile.delete();
//       }
//       await _mRecorder.openAudioSession();
//       _mRecorderIsInited = true;
//     }

//     // ----------------------  Here is the code for recording and playback -------

//     Future<void> record() async {
//       assert(_mRecorderIsInited && _mPlayer.isStopped);
//       await _mRecorder.startRecorder(
//         toFile: _mPath,
//         codec: Codec.mp3,
//       );
//       setState(() {});
//     }

//     Future<void> stopRecorder() async {
//       await _mRecorder.stopRecorder();
//       await addUser();
//       _mplaybackReady = true;
//     }

//   Future<void> addUser() async {
//     firebase_storage.StorageReference ref = firebase_storage
//         .FirebaseStorage.instance
//         .ref()
//         .child("product")
//         .child(uploadTime);

//     firebase_storage.StorageUploadTask uploadTask =
//     ref.putFile(File(_mPath));
//     String downloadUrl = await ref.getDownloadURL();
//     final String url = downloadUrl.toString();
//     recordurl = url;
//     print('recordurl: ' + url);
//   }
//   void Function() getRecorderFn() {
//     if (!_mRecorderIsInited || !_mPlayer.isStopped) {
//       return null;
//     }
//     return _mRecorder.isStopped
//         ? record
//         : () {
//       stopRecorder().then((value) => setState(() {}));
//     };
//   }

//   void showAlertDialog(BuildContext context) async {
//     String result = await showDialog(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('보관함 저장'),
//           content: Column(
//             children: [
//               Container(
//                 child: TextField(
//                   controller: videoTitleController,
//                   decoration: InputDecoration(
//                     hintText: '제목',
//                   ),
//                 ),
//               ),
//               Text('보관함 위치'),
//             ],
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('저장 안 함'),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => MainPage()));
//               },
//             ),
//             FlatButton(
//               child: Text('저장'),
//               onPressed: () async {
// //                await addUser();
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => RecordCheckPage(
//                             originalVideo: widget.originalVideo,
//                             recordVideo: recordurl)));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget showScript(BuildContext context, var script) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height * 0.35,
//       child: ListView.builder(
//         itemCount: script.keys.length ~/ 2,
//         itemBuilder: (context, int index) {
//           String aKey = script.keys.elementAt(index * 2);
//           String sKey = script.keys.elementAt(index * 2 + 1);
//           return ListTile(
//             title: Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("${script[aKey]}",
//                         style: TextStyle(color: Colors.grey)),
//                     Text("${script[sKey].replaceAll('\\n', '\n')}",
//                         style: TextStyle(color: Colors.black)),
//                     SizedBox(height: 100),
//                   ],
//                 )),
//           );
//         },
//       ),
//     );
//   }
// }
