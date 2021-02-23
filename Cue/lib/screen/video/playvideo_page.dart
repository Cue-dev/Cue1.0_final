import 'dart:async';

// import 'package:Cue/screen/Cam/camera_alone.dart';
// import 'package:Cue/screen/Cam/camera_multiplay.dart';
import 'package:Cue/screen/Cam/camera_alone.dart';
import 'package:Cue/screen/Cam/camera_multiplay.dart';
import 'package:Cue/screen/video/cue_dialog.dart';
import 'package:Cue/services/reference_video.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_controls/video_player_controls.dart';

import '../Cam/record_dubbing.dart';

class PlayVideoPage extends StatefulWidget {
  final ReferenceVideo videoToPlay;
  PlayVideoPage({Key key, @required this.videoToPlay}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  Controller controller;

  // var _disposed = false;
  // var _isFullScreen = false;
  // Timer _timerVisibleControl;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoToPlay.videoURL);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    // Screen.keepOn(true);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.initState();

    controller = new Controller(
      items: [
        PlayerItem(
            title: widget.videoToPlay.title, url: widget.videoToPlay.videoURL),
      ],
      autoPlay: true,
      errorBuilder: (context, message) {
        return new Container(
          color: Colors.red,
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
    // _disposed = true;
    // _timerVisibleControl?.cancel();
    // Screen.keepOn(false);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    // _exitFullScreen();
    _controller?.pause(); // mute instantly
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  // void _toggleFullscreen() async {
  //   if (_isFullScreen) {
  //     _exitFullScreen();
  //   } else {
  //     _enterFullScreen();
  //   }
  // }

  // void _enterFullScreen() async {
  //   debugPrint("enterFullScreen");
  //   await SystemChrome.setEnabledSystemUIOverlays([]);
  //   await SystemChrome.setPreferredOrientations(
  //       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //   if (_disposed) return;
  //   setState(() {
  //     _isFullScreen = true;
  //   });
  // }

  // void _exitFullScreen() async {
  //   debugPrint("exitFullScreen");
  //   await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  //   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //   if (_disposed) return;
  //   setState(() {
  //     _isFullScreen = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                // AspectRatio(
                //   aspectRatio: 16 / 9,
                //   child: Container(
                //     color: Colors.black,
                //     child: SizedBox.expand(
                //       child: FittedBox(
                //         fit: BoxFit.fitHeight,
                //         child: SizedBox(
                //           width: _controller.value.size?.width ?? 0,
                //           height: _controller.value.size?.height ?? 0,
                //           child: VideoPlayer(_controller),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // _isFullScreen
                //     ? Container(
                //         child: Center(child: _playView(context)),
                //         decoration: BoxDecoration(color: Colors.black),
                //       )
                //     : Container(
                //         child: Center(child: _playView(context)),
                //         decoration: BoxDecoration(color: Colors.black),
                //       ),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    child: VideoPlayerControls(
                      controller: controller,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          for (int i = 0;
                              i < widget.videoToPlay.tag.length;
                              i++)
                            Text(
                              widget.videoToPlay.tag[i] + ' ',
                              style: Theme.of(context).textTheme.caption,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.videoToPlay.title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            '조회 ' + widget.videoToPlay.views.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '도전 ' + widget.videoToPlay.challenges.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            icon: ImageIcon(
                              AssetImage('icons/대본저장.png'),
                            ),
                            onPressed: () {}),
                        Text('대본만 저장'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            icon: ImageIcon(
                              AssetImage('icons/영상대본저장.png'),
                            ),
                            onPressed: () {}),
                        Text('영상+대본 저장'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            icon: ImageIcon(
                              AssetImage('icons/섀도잉.png'),
                            ),
                            onPressed: () {}),
                        Text('섀도잉'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            icon: ImageIcon(
                              AssetImage('icons/공유.png'),
                            ),
                            onPressed: () {}),
                        Text('공유'),
                      ],
                    ),
                  ],
                ),
                Divider(),
//                Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Text('대본 펼치기'),
//                      SizedBox(width: 200),
//                      IconButton(
//                          icon: Icon(Icons.keyboard_arrow_down),
//                          onPressed: () {}),
//                    ],
//                  ),
//                ),
                showScript(context, widget.videoToPlay.script, mh, mw)
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
          child: Container(
            height: mh * 0.13,
            width: mw * 0.15,
            child: Column(
              children: [
                ImageIcon(
                  AssetImage('icons/큐.png'),
                  size: 50,
                ),
                SizedBox(
                  height: mh * 0.02,
                ),
                Text(
                  'Cue!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 13),
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              controller.pause();
            });

            // Navigator.of(context).push(MaterialPageRoute<Null>(
            //     builder: (BuildContext context) {
            //       return CueDialog(
            //         videoToPlay: widget.videoToPlay,
            //       );
            //     },
            //     fullscreenDialog: true));
            showDialog(
                context: context,
                builder: (_) {
                  return CueDialog(
                    videoToPlay: widget.videoToPlay,
                  );
                });
          }),
    );
  }

  Widget showScript(BuildContext context, Map script, double mh, double mw) {
    return Container(
      height: mh * 0.4,
      width: mw,
      child: ListView.builder(
        itemCount: script.keys.length ~/ 2,
        itemBuilder: (context, int index) {
          return Column(
            children: [
              ListTile(
                leading: Text(
                  "${script['a' + (index + 1).toString()]}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                title: Text(
                    "${script['s' + (index + 1).toString()]}"
                        .replaceAll('\\n', '\n'),
                    style: TextStyle(fontSize: 13)),
              )
            ],
          );
        },
      ),
    );
  }
}
