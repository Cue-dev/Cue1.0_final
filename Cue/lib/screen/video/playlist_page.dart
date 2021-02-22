import 'dart:async';

import 'package:Cue/screen/mypage/scrap_dialog.dart';
import 'package:Cue/screen/video/playvideo_page.dart';
import 'package:Cue/services/video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Cue/services/loading.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/reference_video.dart';

class PlayListPage extends StatefulWidget {
  PlayListPage({Key key}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  Stream<List<ReferenceVideo>> listVideos;
  List<String> videoURLs = List();

  void clearHistory() {
    videoURLs.clear();
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    final referenceVideoModel =
        Provider.of<ReferenceVideoModel>(context, listen: false);

    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                "Cue!",
                style: Theme.of(context).textTheme.headline2,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(30))),
              actions: [
                IconButton(
                    icon: ImageIcon(
                      AssetImage('icons/검색.png'),
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: ImageIcon(
                      AssetImage('icons/알림_유.png'),
                    ),
                    onPressed: () {}),
              ],
            ),
            body: FutureBuilder(
                future: referenceVideoModel.loadReferenceVideos(),
                builder:
                    (context, AsyncSnapshot<List<ReferenceVideo>> snapshot) {
                  return snapshot.hasData
                      ? ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(),
                          padding: EdgeInsets.fromLTRB(
                              mw * 0.02, mh * 0.01, mw * 0.02, mh * 0.01),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            print(snapshot.data.length);
                            return InkWell(
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: mh * 0.31,
                                        width: mw,
                                        child: snapshot
                                                    .data[index].thumbnailURL !=
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  snapshot
                                                      .data[index].thumbnailURL,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(color: Colors.black),
                                      ),
                                      Positioned(
                                        child: topLeftText(
                                            snapshot.data[index].source,
                                            snapshot.data[index].type),
                                        top: mh * 0.02,
                                        left: mw * 0.05,
                                      ),
                                      Positioned(
                                        child: bottomLeftText(
                                            snapshot.data[index].tag,
                                            snapshot.data[index].title,
                                            snapshot.data[index].views,
                                            snapshot.data[index].challenges),
                                        bottom: mh * 0.02,
                                        left: mw * 0.05,
                                      ),
                                      Positioned(
                                        child: IconButton(
                                            iconSize: 15,
                                            icon: ImageIcon(
                                              AssetImage('icons/메뉴.png'),
                                            ),
                                            onPressed: () {
                                              scrapFirstDialog(context);
                                            }),
                                        top: mh * 0.01,
                                        right: mw * 0.005,
                                      ),
                                      Positioned(
                                        child: bottomRightText(
                                            snapshot.data[index].length),
                                        bottom: mh * 0.02,
                                        right: mw * 0.05,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: mh * 0.02,
                                  )
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //       left: mw * 0.02, bottom: mh * 0.02),
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Text(snapshot.data[index].title,
                                  //                 style: Theme.of(context)
                                  //                     .textTheme
                                  //                     .subtitle1),
                                  //             SizedBox(height: 3),
                                  //             Text(
                                  //               snapshot.data[index].tag,
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .caption,
                                  //             )
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              )),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PlayVideoPage(
                                              videoToPlay: snapshot.data[index],
                                            )));
                              },
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          );
  }

  Widget topLeftText(String source, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(source,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.bold)),
        Text(
          type,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }

  Widget bottomLeftText(
      List<String> tag, String title, int views, int challenges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < tag.length; i++)
              Text(
                tag[i],
                style: Theme.of(context).textTheme.caption,
              ),
          ],
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          '',
          style: TextStyle(fontSize: 5),
        ),
        Row(
          children: [
            Text(
              '조회 ' + views.toString(),
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '도전 ' + challenges.toString(),
              style: Theme.of(context).textTheme.subtitle2,
            )
          ],
        ),
      ],
    );
  }

  Widget bottomRightText(int length) {
    String minute = (length ~/ 60).toString();
    String second = (length % 60).toString();
    return Container(
      color: Theme.of(context).primaryColor,
      child: Text(
        '$minute:$second',
        style: Theme.of(context).textTheme.bodyText1,
      ),
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
