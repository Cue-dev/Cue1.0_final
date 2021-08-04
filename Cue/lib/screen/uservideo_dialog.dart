// import 'dart:async';
import 'package:flutter/services.dart';
import 'package:Cue/services/user_video.dart';
import 'package:flutter/material.dart';
// import 'package:neeko/neeko.dart';

class UserVideoDialog extends StatefulWidget {
  final UserVideo videoToPlay;
  UserVideoDialog({Key? key, required this.videoToPlay}) : super(key: key);

  @override
  _UserVideoDialogState createState() => _UserVideoDialogState();
}

class _UserVideoDialogState extends State<UserVideoDialog> {
  // VideoControllerWrapper videoControllerWrapper;
  bool _isExpanded = false;

  @override
  void initState() {
    // videoControllerWrapper = VideoControllerWrapper(DataSource.network(
    //     widget.videoToPlay.videoURL));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      backgroundColor: Colors.black54,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(children: <Widget>[
          Container()
          //   Center(
          //     child:NeekoPlayerWidget(
          //       videoControllerWrapper: videoControllerWrapper,
          //       progressBarHandleColor: Theme.of(context).accentColor,
          //       progressBarPlayedColor: Theme.of(context).accentColor,
          //       onPortraitBackTap: () {
          //         print("====================================================");
          //         Navigator.pop(context);
          //       },
          // )),
        ]),
      ),
    );
  }
}
