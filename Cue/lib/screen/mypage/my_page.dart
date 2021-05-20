import 'package:Cue/screen/dialog/create_saved_list_dialog.dart';
import 'package:Cue/services/database.dart';
import 'package:Cue/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/auth_provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthProvider>(context).getUID;
    DatabaseService db = DatabaseService(uid: uid);

    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;

    return Scaffold(
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
            height: mh * 0.06,
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
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 30,
                        ),
                  ),
                  Text(
                    '연기 취미생',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
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
          Text(
            '팔로워 ' + snapshot.data['follower'].toString() + '명',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            '팔로잉 ' + snapshot.data['following'].toString() + '명',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: mh * 0.02,
          ),
          Text(
            snapshot.data['description'],
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
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
                    .subtitle1
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
            height: mh * 0.48,
            child: TabBarView(
              children: <Widget>[feedTab(mh, mw), storageTab(mh, mw, db)],
            ),
          ),
        ],
      ),
    );
  }

  Widget feedTab(var mh, var mw) {
    List<String> url = [
      'https://pds.joins.com/news/component/htmlphoto_mmdata/202006/12/0befd24a-58a5-48bc-9bd5-3a07fbaf3077.jpg',
      'https://mimgnews.pstatic.net/image/438/2019/08/29/201908292597_20190829184741005.jpg?type=w540',
      'https://img.etnews.com/news/article/2018/02/02/cms_temp_article_02112847612319.jpg'
    ];
    List<String> title = ['급박한 상황, 약간의 액션..', '사랑, 남자친구와 함께 영..', '첫 연기 도전!'];

    return Container(
      color: Theme.of(context).primaryColor,
      child: GridView.builder(
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: mw * 0.49,
              height: mh * 0.1,
              child: Image.network(
                url[index],
                fit: BoxFit.fitHeight,
              ),
            );
          }),
    );
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
                        .subtitle1
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
              height: mh * 0.4,
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
    return StreamBuilder(
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
                Flexible(
                  child: ListView(
                    itemExtent: mh * 0.055,
                    shrinkWrap: true,
                    children: snapshot.data.docs.map<Widget>((value) {
                      return ListTile(
                        title: Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(value.id)),
                        onTap: () {
                          print('s');
                        },
                      );
                    }).toList(),
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
                              return CreateSavedListDialog();
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
}
