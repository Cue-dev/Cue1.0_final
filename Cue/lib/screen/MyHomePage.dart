import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:neeko/neeko.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  static const String beeUri = 'https://media.w3.org/2010/05/sintel/trailer.mp4';

  // final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
  //     DataSource.network(
  //         'https://firebasestorage.googleapis.com/v0/b/cue-cb58c.appspot.com/o/videos%2FItaewonclass_Trim.mp4?alt=media&token=aa85c913-806d-4ed7-9687-bca3748a2196',
  //         displayName: "displayName"));

//  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
//      DataSource.network(
//          'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
//          displayName: "displayName"));

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      // body: NeekoPlayerWidget(
      //   onSkipPrevious: () {
      //     print("skip");
      //     videoControllerWrapper.prepareDataSource(DataSource.network(
      //         "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312083533415853.mp4",
      //         displayName: "This house is not for sale"));
      //   },
      //   onSkipNext: () {
      //     videoControllerWrapper.prepareDataSource(DataSource.network(
      //         'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
      //         displayName: "displayName"));
      //   },
      //   videoControllerWrapper: videoControllerWrapper,
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
    );
  }
}
