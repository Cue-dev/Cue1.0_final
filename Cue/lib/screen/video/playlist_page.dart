import 'dart:async';

import 'package:Cue/screen/dialog/save_script_dialog.dart';
import 'package:Cue/screen/dialog/save_video_dialog.dart';
import 'package:Cue/screen/mypage/my_page.dart';
import 'package:Cue/screen/search/search_result_page.dart';
import 'package:Cue/screen/video/playvideo_page.dart';
import 'package:Cue/services/reference_video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Cue/services/loading.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/reference_video.dart';

class PlayListPage extends StatefulWidget {
  PlayListPage({Key? key}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  Stream<List<ReferenceVideo>>? listVideos;
  List<String> videoURLs = [];

  void clearHistory() {
    videoURLs.clear();
  }

  late SearchBar searchBar;
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        "Cue!",
        style: Theme.of(context).textTheme.headline2,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))),
      actions: [
        // IconButton(
        //     icon: ImageIcon(
        //       AssetImage('icons/검색.png'),
        //     ),
        //     onPressed: () {
        //       searchBar.beginSearch(context);
        //     }),
        IconButton(
            icon: ImageIcon(
              // AssetImage('icons/알림_유.png'),
              AssetImage('icons/마이.png'),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyPage()));
            }),
      ],
    );
  }

  _PlayListPageState() {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        buildDefaultAppBar: buildAppBar,
        hintText: "검색어를 입력하세요.",
        onSubmitted: (value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchResultPage()));
        });
  }

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    final referenceVideoModel =
        // Provider.of<ReferenceVideoModel>(context, listen: false);
        context.read<ReferenceVideoModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: searchBar.build(context),
      body: FutureBuilder(
          future: referenceVideoModel.loadReferenceVideos(),
          builder: (context, AsyncSnapshot<List<ReferenceVideo>> snapshot) {
            return snapshot.hasData
                ? ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(),
                    padding: EdgeInsets.fromLTRB(
                        mw * 0.02, mh * 0.01, mw * 0.02, mh * 0.01),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, int index) {
                      print(snapshot.data!.length);
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
                                  child: snapshot.data![index].thumbnailURL !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            snapshot.data![index].thumbnailURL!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(color: Colors.black),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black54,
                                          Colors.black12,
                                        ],
                                      )),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: mw * 0.03, top: mh * 0.008),
                                        child: Row(
                                          children: [
                                            Positioned(
                                              child: topLeftText(
                                                  snapshot.data![index].source!,
                                                  snapshot.data![index].type!),
                                              top: mh * 0.02,
                                              left: mw * 0.05,
                                            ),
                                            Spacer(),
                                            Positioned(
                                              child: IconButton(
                                                  iconSize: 15,
                                                  icon: ImageIcon(
                                                    AssetImage('icons/메뉴.png'),
                                                  ),
                                                  onPressed: () {
                                                    saveDialog(context, mw, mh,
                                                        snapshot.data![index]);
                                                  }),
                                              top: mh * 0.01,
                                              right: mw * 0.005,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: mh * 0.178),
                                    Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black12,
                                          Colors.black54,
                                        ],
                                      )),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: mw * 0.02, right: mw * 0.03),
                                        child: Row(
                                          children: [
                                            Positioned(
                                              child: bottomLeftText(
                                                  snapshot.data![index].tag!,
                                                  snapshot.data![index].title!,
                                                  snapshot.data![index].views,
                                                  snapshot
                                                      .data![index].challenges),
                                              bottom: mh * 0.02,
                                              left: mw * 0.05,
                                            ),
                                            Spacer(),
                                            Positioned(
                                              child: bottomRightText(snapshot
                                                  .data![index].length!),
                                              bottom: mh * 0.02,
                                              right: mw * 0.05,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        videoToPlay: snapshot.data![index],
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
                .subtitle2!
                .copyWith(fontWeight: FontWeight.bold)),
        Text(
          type,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }

  Widget bottomLeftText(
      List<String> tag, String title, int? views, int? challenges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < tag.length; i++)
              Text(
                ' ' + tag[i] + ' ',
                style: Theme.of(context).textTheme.caption,
              ),
          ],
        ),
        Text(
          ' ' + title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          '',
          style: TextStyle(fontSize: 5),
        ),
        // Row(
        //   children: [
        //     Text(
        //       '조회 ' + views.toString(),
        //       style: Theme.of(context).textTheme.subtitle2,
        //     ),
        //     SizedBox(
        //       width: 5,
        //     ),
        //     Text(
        //       '도전 ' + challenges.toString(),
        //       style: Theme.of(context).textTheme.subtitle2,
        //     )
        //   ],
        // ),
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

  void saveDialog(BuildContext context, double mw, double mh, var video) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.only(top: mh * 0.63),
            child: Padding(
              padding: EdgeInsets.all(mh * 0.015),
              child: Column(
                children: [
                  InkWell(
                    child: _buildDialogButtons(
                        mw, mh, 'icons/대본저장.png', '대본만 저장하기'),
                    onTap: () {
                      saveScriptDialog(context, video);
                    },
                  ),
                  InkWell(
                    child: _buildDialogButtons(
                        mw, mh, 'icons/영상대본저장.png', '영상+대본 저장하기'),
                    onTap: () {
                      saveVideoDialog(context, video);
                    },
                  ),
                  InkWell(
                    child: _buildDialogButtons(mw, mh, 'icons/공유.png', '공유하기'),
                    onTap: () {},
                  ),
                  Divider(),
                  InkWell(
                    child: _buildDialogButtons(mw, mh, 'icons/취소.png', '취소'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildDialogButtons(double mw, double mh, String icon, String text) {
    return Container(
      width: mw,
      height: mh * 0.07,
      child: Row(
        children: [
          SizedBox(
            width: mw * 0.03,
          ),
          ImageIcon(
            AssetImage(icon),
          ),
          SizedBox(
            width: mw * 0.035,
          ),
          Expanded(child: Text(text))
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
