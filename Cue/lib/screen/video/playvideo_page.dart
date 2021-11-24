// import 'dart:async';
import 'package:Cue/screen/dialog/save_script_dialog.dart';
import 'package:Cue/screen/dialog/save_video_dialog.dart';
import 'package:flutter/services.dart';
import 'package:Cue/screen/dialog/cue_dialog.dart';
import 'package:Cue/services/reference_video.dart';
// import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_player_controls/video_player_controls.dart';
// import 'package:neeko/neeko.dart';

class PlayVideoPage extends StatefulWidget {
  final ReferenceVideo videoToPlay;
  PlayVideoPage({Key? key, required this.videoToPlay}) : super(key: key);

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  // VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;
  // VideoControllerWrapper videoControllerWrapper;

  // Controller controller;

  bool _isExpanded = false;

  @override
  void initState() {
    // videoControllerWrapper = VideoControllerWrapper(DataSource.network(
    //     widget.videoToPlay.videoURL,
    //     displayName: widget.videoToPlay.title));

    // _controller = VideoPlayerController.network(widget.videoToPlay.videoURL);
    // _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.setLooping(true);
    super.initState();

    // controller = new Controller(
    //   items: [
    //     PlayerItem(
    //         title: widget.videoToPlay.title, url: widget.videoToPlay.videoURL),
    //   ],
    //   autoPlay: true,
    //   errorBuilder: (context, message) {
    //     return new Container(
    //       color: Colors.red,
    //       child: new Text(message),
    //     );
    //   },
    //   autoInitialize: true,
    //   hasSubtitles: true,
    //   showSkipButtons: false,
    //   allowFullScreen: true,
    //   fullScreenByDefault: false,
    // );
  }

  @override
  void dispose() {
    // _controller?.pause(); // mute instantly
    // _controller?.dispose();
    // _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
      // body: FutureBuilder(
      //   future: _initializeVideoPlayerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return Column(
      body: Column(
        children: [
          // AspectRatio(
          //   aspectRatio: 16 / 9,
          //   child: Container(
          //     child: VideoPlayerControls(
          //       controller: controller,
          //     ),
          //   ),
          // ),
          // NeekoPlayerWidget(
          //   videoControllerWrapper: videoControllerWrapper,
          //   progressBarHandleColor: Theme.of(context).accentColor,
          //   progressBarPlayedColor: Theme.of(context).accentColor,
          //   onPortraitBackTap: () {
          //     Navigator.pop(context);
          //   },
          //   actions: <Widget>[
          //     IconButton(
          //         icon: Icon(
          //           Icons.share,
          //           color: Colors.white,
          //         ),
          //         onPressed: () {
          //           print("share");
          //         })
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mw * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mh * 0.01,
                ),
                Row(
                  children: [
                    for (int i = 0; i < widget.videoToPlay.tag!.length; i++)
                      Text(
                        widget.videoToPlay.tag![i] + ' ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                  ],
                ),
                SizedBox(
                  height: mh * 0.003,
                ),
                Text(
                  widget.videoToPlay.title!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  height: mh * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      '조회 ' + widget.videoToPlay.views.toString(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      width: mw * 0.015,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: mh * 0.001),
                    child: IconButton(
                        icon: ImageIcon(
                          AssetImage('icons/대본저장.png'),
                        ),
                        onPressed: () {
                          saveScriptDialog(context, widget.videoToPlay);
                        }),
                  ),
                  _isExpanded ? Container() : Text('대본만 저장'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                      icon: ImageIcon(
                        AssetImage('icons/영상대본저장.png'),
                      ),
                      onPressed: () {
                        saveVideoDialog(context, widget.videoToPlay);
                      }),
                  _isExpanded ? Container() : Text('영상+대본 저장'),
                ],
              ),
              // Column(
              //   children: [
              //     IconButton(
              //         icon: ImageIcon(
              //           AssetImage('icons/섀도잉.png'),
              //         ),
              //         onPressed: () {}),
              //     _isExpanded ? Container() : Text('섀도잉'),
              //   ],
              // ),
              // Column(
              //   children: [
              //     IconButton(
              //         icon: ImageIcon(
              //           AssetImage('icons/공유.png'),
              //         ),
              //         onPressed: () {}),
              //     _isExpanded ? Container() : Text('공유'),
              //   ],
              // ),
            ],
          ),
          Divider(),
          // ConfigurableExpansionTile(
          //   header: Container(
          //     width: mw,
          //     height: mh * 0.045,
          //     padding: EdgeInsets.symmetric(horizontal: mw * 0.05),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Align(alignment: Alignment.centerLeft, child: Text('대본 보기')),
          //         Align(
          //             alignment: Alignment.centerRight,
          //             child: Icon(Icons.keyboard_arrow_down))
          //       ],
          //     ),
          //   ),
          //   headerExpanded: Column(
          //     children: [
          //       Container(
          //         width: mw,
          //         height: mh * 0.038,
          //         padding: EdgeInsets.symmetric(horizontal: mw * 0.05),
          //         child: Align(
          //             alignment: Alignment.centerRight, child: Text('닫기')),
          //       ),
          //       SizedBox(
          //         height: mh * 0.007,
          //       )
          //     ],
          //   ),
          //   onExpansionChanged: (value) {
          //     setState(() {
          //       _isExpanded = value;
          //     });
          //   },
          //   children: [showScript(context, widget.videoToPlay.script, mh, mw)],
          // ),
          _isExpanded ? Container() : challengeSection(mh, mw),
        ],
      ),
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
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
                      .bodyText1!
                      .copyWith(fontSize: 13),
                )
              ],
            ),
          ),
          onTap: () {
            // setState(() {
            //   controller.pause();
            // });
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
      height: _isExpanded ? mh * 0.345 : 0,
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
                      .bodyText1!
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

  Widget challengeSection(double mh, double mw) {
    //TODO : 도전영상들 보여주기 말고 진짜로 띄우기...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(
          height: mh * 0.01,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mw * 0.05),
          child: Text("도전영상"),
        ),
        SizedBox(
          height: mh * 0.01,
        ),
        Container(
          height: mh * 0.3,
          child: ListView(
            children: [
              personTile(mh, mw, "1.png", "딕션 연습(첫 영상)", "2일 전", "미연 배우"),
              personTile(mh, mw, "2.png", "표정연기좀 봐주세요!", "1주 전", "김영우 배우"),
              personTile(mh, mw, "3.png", "대본 없는 첫 연기", "3일 전", "예원 배우"),
            ],
          ),
        )
      ],
    );
  }

  Widget personTile(double mh, double mw, String image, String title,
      String date, String uploader) {
    return ListTile(
      leading:
          AspectRatio(aspectRatio: 16 / 9, child: Image.asset('images/$image')),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: mh * 0.01,
          ),
          Text(
            uploader,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }

  void saveVideoDialog(BuildContext context, ReferenceVideo videoToSave) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SaveVideoDialog(videoToSave: videoToSave);
        });
  }

  void saveScriptDialog(
      BuildContext context, ReferenceVideo videoToSaveScript) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SaveScriptDialog(
              scriptSource: videoToSaveScript.source,
              scriptTitle: videoToSaveScript.title,
              scriptToSave: videoToSaveScript.script);
        });
  }
}
