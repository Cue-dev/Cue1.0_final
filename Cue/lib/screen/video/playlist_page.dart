import 'dart:async';

import 'package:Cue/screen/mypage/scrap_dialog.dart';
import 'package:Cue/screen/video/playvideo_page.dart';
import 'package:Cue/services/video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Cue/services/loading.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/video.dart';
// import 'package:cue/video_control/video_bloc.dart';
// import 'package:cue/video_control/video_api.dart';

class PlayListPage extends StatefulWidget {
  PlayListPage({Key key}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  Stream<List<Video>> listVideos;

  // VideosBloc _videosBloc;

  List<String> videoURLs = List();

  void clearHistory() {
    videoURLs.clear();
  }

  bool _loading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   clearHistory();

  //   setState(() {
  //     _loading = true;
  //   });
  //   _videosBloc = VideosBloc(VideosAPI());
  //   listVideos = _videosBloc.listVideos;

  //   if (listVideos != null) {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    final videoModel = Provider.of<VideoModel>(context, listen: false);

    return _loading
        ? Loading()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0.0,
                  title: Text(
                    "Cue!",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  actions: [
                    IconButton(
                        iconSize: 40.0,
                        icon: ImageIcon(
                          AssetImage('icons/검색.png'),
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                    IconButton(
                        iconSize: 40.0,
                        icon: ImageIcon(
                          AssetImage('icons/메세지.png'),
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                  ],
                  bottom: TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.grey,
                    tabs: [
                      Tab(text: '추천 연기'),
                      Tab(text: '인기 도전'),
                    ],
                  ),
                ),
                body: TabBarView(children: <Widget>[
                  // middleSection,
                  FutureBuilder(
                      future: videoModel.loadVideos(),
                      builder: (context, AsyncSnapshot<List<Video>> snapshot) {
                        return snapshot.hasData
                            ? ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                padding: EdgeInsets.fromLTRB(
                                    mw * 0.02, mh * 0.01, mw * 0.02, mh * 0.01),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  print(snapshot.data.length);
                                  return InkWell(
                                    child: Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: mh * 0.3,
                                              width: mw,
                                              child: snapshot.data[index]
                                                          .thumbnailURL !=
                                                      null
                                                  ? Image.network(
                                                      snapshot.data[index]
                                                          .thumbnailURL,
                                                      fit: BoxFit.fitWidth,
                                                    )
                                                  : Container(
                                                      color: Colors.black),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Container(
                                                width: mw * 0.25,
                                                height: mh * 0.025,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      snapshot
                                                          .data[index].source,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mw * 0.02,
                                              bottom: mh * 0.02),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        snapshot
                                                            .data[index].title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      snapshot.data[index].tag,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                  iconSize: 40.0,
                                                  icon: ImageIcon(
                                                    AssetImage('icons/스크랩.png'),
                                                  ),
                                                  onPressed: () {
                                                    scrapFirstDialog(context);
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlayVideoPage(
                                                    videoToPlay:
                                                        snapshot.data[index],
                                                  )));
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
//
                  FutureBuilder(
                      future: videoModel.loadVideos(),
                      builder: (context, AsyncSnapshot<List<Video>> snapshot) {
                        return snapshot.hasData
                            ? ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                padding: EdgeInsets.fromLTRB(
                                    mw * 0.02, mh * 0.01, mw * 0.02, mh * 0.01),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  print(snapshot.data.length);
                                  return InkWell(
                                    child: Container(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: mh * 0.3,
                                              width: mw,
                                              child: Image.network(
                                                  'https://i.ytimg.com/vi/UwkWHunhbtI/maxresdefault.jpg'),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mw * 0.02,
                                              bottom: mh * 0.02),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '[국가부도의 날] 유아인 독백연기 도전',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      '#유아인 #독백연기 #서울예대 #배우지망생',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                    SizedBox(height: mh * 0.01),
                                                    Row(
                                                      children: [
                                                        Text('김배우'),
                                                        SizedBox(
                                                            width: mw * 0.04),
                                                        Text('조회수 2.3천'),
                                                        SizedBox(
                                                            width: mw * 0.04),
                                                        Text('3일 전'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                      iconSize: 30.0,
                                                      icon: ImageIcon(
                                                          AssetImage(
                                                              'icons/좋아요.png')),
                                                      onPressed: () {}),
                                                  Text('1231',
                                                      style: TextStyle(
                                                          fontSize: 10))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                    onTap: () {},
                                  );
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                ])),
          );
  }

  void scrapFirstDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Container(
                                  child: Row(
                                children: [
                                  Image.asset('icons/영상 아이콘.png'),
                                  Text(' + '),
                                  Image.asset('icons/대본 아이콘.png')
                                ],
                              )),
                            ),
                            Text('영상+대본', style: TextStyle(fontSize: 15)),
                            Text('스크랩', style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                      onTap: () {
                        scrapSecondDialog(context);
                      }),
                ),
                VerticalDivider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 10, 10.0),
                  child: InkWell(
                    child: Container(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Image.asset('icons/대본 아이콘.png'),
                        ),
                        Text('대본만', style: TextStyle(fontSize: 15)),
                        Text('스크랩', style: TextStyle(fontSize: 15))
                      ],
                    )),
                    onTap: () {
                      scrapSecondDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<bool> checked = [false, false, false, false];
  List<String> scraplist = ['좋아하는 영화 명대사', '딕션 연습', '눈물 연기 연습', '분노 연기 연습'];

  void scrapSecondDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog();
        });
  }
}
//  Widget get middleSection => Expanded(child: videoViewer());
//
//  Widget videoViewer() {
//    // return ListView(
//    //     children:
//    //         Provider.of<VideoModel>(context, listen: false).videos.map((video) {
//    //   print(video.title);
//    //   return ListTile(leading: Text(video.title));
//    // }).toList());
//
//    // return Column(
//    //   children: [
//    //     builder: ,)
//    //   ],
//    // );
//
//    // return Container(
//    //     child: Center(
//    //         child: StreamBuilder(
//    //             initialData: List<Video>(),
//    //             stream: listVideos,
//    //             builder: (BuildContext context, AsyncSnapshot snapshot) {
//    //               if (!snapshot.hasData) {
//    //                 return CircularProgressIndicator();
//    //               } else {
//    //                 List<Video> videos = snapshot.data;
//    //                 if (videos.length > 0) {
//    //                   print(
//    //                       '||||||||||||||||||||||||||length : ${videos.length}');
//    //                   return PageView.builder(
//    //                     controller: PageController(
//    //                       initialPage: 0,
//    //                       viewportFraction: 1,
//    //                     ),
//    //                     onPageChanged: (index) {
//    //                       index = index % (videos.length);
//    //                       _videosBloc.videoManager.changeVideo(index);
//    //                     },
//    //                     scrollDirection: Axis.vertical,
//    //                     itemBuilder: (context, index) {
//    //                       index = index % (videos.length);
//    //                       return videoCard(
//    //                           _videosBloc.videoManager.listVideos[index]);
//    //                     },
//    //                   );
//    //                 } else {
//    //                   return CircularProgressIndicator();
//    //                 }
//    //               }
//    //             })));
//  }
//
//  Widget videoCard(Video video) {
//    var controller = video.controller;
//    return Stack(
//      alignment: Alignment.bottomCenter,
//      children: <Widget>[
//        controller != null && controller.value.initialized
//            ? GestureDetector(
//                onTap: () {
//                  controller.value.isPlaying
//                      ? controller.pause()
//                      : controller.play();
//                },
//                child: SizedBox.expand(
//                    child: FittedBox(
//                  fit: BoxFit.cover,
//                  child: SizedBox(
//                    width: controller.value.size?.width ?? 0,
//                    height: controller.value.size?.height ?? 0,
//                    child: VideoPlayer(controller),
//                  ),
//                )))
//            : Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  LinearProgressIndicator(),
//                  SizedBox(
//                    height: 56,
//                  )
//                ],
//              ),
//        // Column(
//        //   mainAxisAlignment: MainAxisAlignment.end,
//        //   children: <Widget>[
//        //     Row(
//        //       mainAxisSize: MainAxisSize.max,
//        //       crossAxisAlignment: CrossAxisAlignment.end,
//        //       children: <Widget>[],
//        //     ),
//        //     SizedBox(height: 65)
//        //   ],
//        // )
//      ],
//    );
//  }
//}
