import 'dart:async';

import 'package:Cue/screen/uservideo_dialog.dart';
import 'package:Cue/screen/video/playvideo_page.dart';
import 'package:Cue/services/user_video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Cue/services/loading.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/user_video.dart';

class PopularPage extends StatefulWidget {
  PopularPage({Key? key}) : super(key: key);

  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  Stream<List<UserVideo>>? listVideos;
  List<String> videoURLs = [];
  TextEditingController _textEditingController = TextEditingController();

  void clearHistory() {
    videoURLs.clear();
  }

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    final userVideoModel = Provider.of<UserVideoModel>(context, listen: false);

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
                future: userVideoModel.loadUserVideos(),
                builder: (context, AsyncSnapshot<List<UserVideo>> snapshot) {
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
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return UserVideoDialog(
                                                  videoToPlay:
                                                      snapshot.data![index],
                                                );
                                              });
                                        },
                                        child: Container(
                                          height: mh * 0.24,
                                          width: mw,
                                          child: snapshot.data![index]
                                                      .thumbnailURL !=
                                                  null
                                              ? Container(
                                                  child: Image.network(
                                                    snapshot.data![index]
                                                        .thumbnailURL!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(color: Colors.black),
                                        ),
                                      ),
                                      Positioned(
                                        child: topLeftText(
                                            snapshot.data![index].profileURL!,
                                            snapshot.data![index].nickname!),
                                        top: mh * 0.01,
                                        left: mw * 0.03,
                                      ),
                                      Positioned(
                                        child: bottomLeftText(
                                          snapshot.data![index].views,
                                        ),
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
                                              menuDialog(context, mw, mh,
                                                  snapshot.data![index]);
                                            }),
                                        top: mh * 0.0001,
                                        right: mw * 0.003,
                                      ),
                                      Positioned(
                                        child: bottomRightText(
                                            snapshot.data![index].length!),
                                        bottom: mh * 0.02,
                                        right: mw * 0.05,
                                      ),
                                    ],
                                  ),
                                  Container(
                                      child: Column(
                                    children: [
                                      Row(children: [
                                        IconButton(
                                            iconSize: 20,
                                            icon: ImageIcon(
                                              AssetImage('icons/하트.png'),
                                            ),
                                            onPressed: () {}),
                                        Text(
                                          snapshot.data![index].likes == 0
                                              ? '아직 좋아요가 없습니다'
                                              : '${snapshot.data![index].likes}명이 좋아합니다.',
                                          style: TextStyle(fontSize: mw * 0.03),
                                        ),
                                        Spacer(),
                                        snapshot.data![index].join == true
                                            ? InkWell(
                                                onTap: () {},
                                                child: Container(
                                                    width: mw * 0.19,
                                                    height: mh * 0.03,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.white),
                                                    child: Center(
                                                      child: Text(
                                                        '같이하기',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                              )
                                            : Container(),
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (BuildContext context) =>
                                            //             PlayVideoPage(
                                            //               videoToPlay: snapshot.data[index].,
                                            //            ))); //TODO : DB 고민
                                          },
                                          child: Container(
                                              width: mw * 0.19,
                                              height: mh * 0.03,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white),
                                              child: Center(
                                                child: Text(
                                                  '원본보기',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        )
                                      ]),
                                      Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data![index].description!
                                                    .replaceAll("\\n", "\n"),
                                              ),
                                              SizedBox(height: mh * 0.01),
                                              Text(
                                                  '댓글 ${snapshot.data![index].comments}개 모두 보기',
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(height: mh * 0.01),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: mw * 0.05,
                                                    height: mh * 0.05,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(width: mw * 0.02),
                                                  Text('댓글달기',
                                                      style: TextStyle(
                                                          color: Colors.grey))
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  )),
                                ],
                              )),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          );
  }

  Widget topLeftText(String profileURL, String uploader) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.07,
            child: Image.network(profileURL),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            uploader,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ],
    );
  }

  Widget bottomLeftText(int? views) {
    return Row(
      children: [
        Text(
          '조회 ' + views.toString(),
          style: Theme.of(context).textTheme.subtitle2,
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

  void menuDialog(BuildContext context, double mw, double mh, var video) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.only(top: mh * 0.63),
            child: Padding(
              padding: EdgeInsets.all(mh * 0.015),
              child: Column(
                children: [
                  InkWell(
                    child: _buildDialogButtons(
                        mw, mh, 'icons/대본저장.png', '신고하기'), // 신고하기 png 요구할 것!
                    onTap: () {},
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
}
