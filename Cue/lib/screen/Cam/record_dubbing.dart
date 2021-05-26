import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';

import '../../services/reference_video.dart';

class DubbingPage extends StatefulWidget {
  final ReferenceVideo originalVideo;
  DubbingPage({Key key, @required this.originalVideo}) : super(key: key);

  @override
  _DubbingPageState createState() {
    return _DubbingPageState();
  }
}

class _DubbingPageState extends State<DubbingPage> {
  VideoPlayerController videocontroller;
  String videoPath;
  String recordurl;
  int selectedCameraIdx;

  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  String _mPath;

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    // onChange: (value) => print('onChange $value'),
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final String uploadTime =
  ('${DateTime.now().year.toString()}:${DateTime.now().month.toString()}:${DateTime.now().day.toString()} ${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}:${DateTime.now().second.toString()}');

  @override
  void initState() {
    super.initState();
    videocontroller =
    VideoPlayerController.network(widget.originalVideo.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          videocontroller.setVolume(0.0);
        });
      });
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
  }
  @override
  void dispose() {
    stopRecorder();
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    if (_mPath != null) {
      var outputFile = File(_mPath);
      if (outputFile.existsSync()) {
        outputFile.delete();
      }
    }
    super.dispose();
  }
  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.mp3';
    var outputFile = File(_mPath);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  Future<void> record() async {
    assert(_mRecorderIsInited );
    await _mRecorder.startRecorder(
      toFile: _mPath,
      codec: Codec.aacMP4, //aacADTS
    );
    setState(() {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      videocontroller.play();
    });
  }

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    addUser();
  }
  Future<void> addUser() async {
    firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("userDubbing")
        .child(uploadTime);

    firebase_storage.UploadTask uploadTask =
    ref.putFile(File(_mPath));
    String downloadUrl = await ref.getDownloadURL();
    final String url = downloadUrl.toString();
  }
  void Function() getRecorderFn() {
    if (!_mRecorderIsInited){
      return null;
    }
    return _mRecorder.isStopped
        ? record
        : () {
      stopRecorder().then((value) => setState(() {
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        videocontroller.pause();

      }));
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body:
      Column(
        children: [
          Stack(
           children: <Widget>[
             Container(
              child: videocontroller.value.initialized
                  ? //ColorFiltered(
                 // child:
                  AspectRatio(
                    aspectRatio: videocontroller.value.aspectRatio,
                    child: VideoPlayer(videocontroller),
                  )
                 // colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation,),)
                  : Container(),
            ),
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
                     ),
                     SizedBox(
                         width: MediaQuery.of(context).size.width * 0.02),
                   ],
                 ),
               ),
             ),
           ]
          ),
          showScript(context, widget.originalVideo.script),
          Container(
           child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                      child: Transform.scale(
                      scale: 1.1,
                      child: Image.asset('icons/녹음.png')
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top : MediaQuery.of(context).size.height * 0.23),
                  child: Center(
                    child: StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data;
                        final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                        return Column(
                          children: <Widget>[
                             Text(
                                displayTime,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ]
           )
          ),
          _captureControlRowWidget(),
        ],
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
              child: Transform.scale(
                scale: 3,
                child: IconButton(
                  onPressed:getRecorderFn(),
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  icon: _mRecorder.isRecording
                      ? ImageIcon(AssetImage('icons/큐_활성.png'),color: Colors.yellow)
                      : ImageIcon(AssetImage('icons/큐.png')),
              )
              )
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget showScript(BuildContext context, var script) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        itemCount: script.keys.length ~/ 2,
        itemBuilder: (context, int index) {
          String aKey = script.keys.elementAt(index * 2);
          String sKey = script.keys.elementAt(index * 2 + 1);
          return ListTile(
            title:Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.005, bottom: MediaQuery.of(context).size.height * 0.005),
                            child: Center(
                              child: Text("${script[aKey]}",
                                  style: TextStyle(color: Colors.black, fontSize: 13)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text("${script[sKey]}",
                            style: TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
