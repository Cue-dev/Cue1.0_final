import 'package:Cue/screen/dialog/create_saved_list_dialog.dart';
import 'package:Cue/services/database.dart';
import 'package:Cue/services/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/auth_provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //TODO: 이거 리스트 갯수 50개로 제한함. 이걸 고치거나 리스트 개수를 제한하는 코드를 추가하거나.
  final List<bool?> _isExpanded = List<bool?>.filled(50, null, growable: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);

    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: FutureBuilder(
          future: db.userCollection.doc(uid).get(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(children: [
                    topSection(mh, mw, snapshot),
                    Divider(
                      color: Theme.of(context).secondaryHeaderColor,
                      thickness: 1,
                    ),
                    tabBarSection(mh, mw, db),
                  ])
                : Loading();
          }),
    );
  }

  Widget topSection(double mh, double mw, var snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mw * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // height: mh * 0.06,
            height: mh * 0.08,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                radius: 40,
              ),
              SizedBox(
                width: mw * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data['name'],
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 30,
                        ),
                  ),
                  Text(
                    '연기 취미생',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.grey, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: mh * 0.02,
          ),
          //TODO: 디비에서 팔로워랑 팔로잉 단숫 숫자로 해도 대냐? 사람들 리스트로 하는건?
          // Text(
          //   '팔로워 ' + snapshot.data['follower'].toString() + '명',
          //   style: Theme.of(context)
          //       .textTheme
          //       .subtitle1!
          //       .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // Text(
          //   '팔로잉 ' + snapshot.data['following'].toString() + '명',
          //   style: Theme.of(context)
          //       .textTheme
          //       .subtitle1!
          //       .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // SizedBox(
          //   height: mh * 0.02,
          // ),
          Text(
            snapshot.data['description'],
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
          ),
          SizedBox(
            height: mh * 0.01,
          ),
        ],
      ),
    );
  }

  Widget tabBarSection(double mh, double mw, DatabaseService db) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: mw * 0.4,
              child: TabBar(
                labelStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "게시물"),
                  Tab(text: "보관함"),
                ],
              ),
            ),
          ),
          Container(
            // height: mh * 0.48,
            height: mh * 0.64,
            child: TabBarView(
              children: <Widget>[feedTab(mh, mw, db), storageTab(mh, mw, db)],
            ),
          ),
        ],
      ),
    );
  }

  Widget feedTab(var mh, var mw, DatabaseService db) {
    List<String> url = [];

    return StreamBuilder<QuerySnapshot>(
        stream: db.userVideoCollection
            .where('uploader', isEqualTo: db.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Loading();
          else {
            return Container(
              color: Theme.of(context).primaryColor,
              child: GridView.builder(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        snapshot.data!.docs[index]['thumbnailURL'],
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  }),
            );
          }
        });
  }

  Widget storageTab(double mh, double mw, DatabaseService db) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mw * 0.02),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: mh * 0.02),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: mh * 0.04,
                  width: mw * 0.5,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).secondaryHeaderColor),
                    labelColor: Theme.of(context).primaryColor,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        child: Container(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("영상+대본")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Align(
                              alignment: Alignment.center, child: Text("대본")),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: mh * 0.42,
              child: TabBarView(
                children: <Widget>[
                  savedVideoTab(mh, mw, db),
                  savedScriptTab(mh, mw)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget savedVideoTab(double mh, double mw, DatabaseService db) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.userCollection
          .doc(db.uid)
          .collection('savedVideoList')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: mw * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mh * 0.02,
                ),
                Container(
                  height: mh * 0.3,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionPanelList(
                        children: [
                          // TODO: 패널사이즈..
                          ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return Padding(
                                padding: EdgeInsets.only(left: mw * 0.03),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    snapshot.data!.docs[index].id,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              );
                            },
                            isExpanded: _isExpanded[index] == null
                                ? false
                                : _isExpanded[index]!,
                            body: StreamBuilder<QuerySnapshot>(
                              stream: db.userCollection
                                  .doc(db.uid)
                                  .collection('savedVideoList')
                                  .doc(snapshot.data!.docs[index].id)
                                  .collection(snapshot.data!.docs[index].id)
                                  .snapshots(),
                              builder: (context, listSnap) {
                                if (!listSnap.hasData) {
                                  return Loading();
                                } else {
                                  return Container(
                                    height: mh * 0.05,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: mw * 0.05),
                                    child: ListView.builder(
                                      itemCount: listSnap.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int idx) {
                                        return listSnap.data!.docs[idx].id
                                                    .trim() !=
                                                "getListName"
                                            ? Container(
                                                height: mh * 0.05,
                                                child: Text(listSnap
                                                    .data!.docs[idx].id))
                                            : Container();
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                        expansionCallback: (int item, bool status) {
                          setState(() {
                            _isExpanded[index] == null
                                ? _isExpanded[index] = true
                                : _isExpanded[index] = !_isExpanded[index]!;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: mh * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: mw * 0.05,
                    ),
                    InkWell(
                      child: Text(
                        '+ 저장 목록 추가',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CreateSavedListDialog(isVideo: true);
                            });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget savedScriptTab(double mh, double mw) {
    return Container();
  }

  // List<Widget> showSavedVideoList(DatabaseService db, String listName) {
  //   List<Widget> savedVideoTile = [];

  //   db.userCollection
  //       .doc(db.uid)
  //       .collection('savedVideoList')
  //       .doc(listName)
  //       .collection(listName)
  //       .get()
  //       .then((value) => value.docs.forEach((doc) => print(doc.id)
  //           // doc.id.trim() != "getListName"
  //           //     ? savedVideoTile.add(ListTile(
  //           //         title: Text(doc.id),
  //           //       ))
  //           //     : null
  //           ));

  //   return savedVideoTile;
  // }
}
