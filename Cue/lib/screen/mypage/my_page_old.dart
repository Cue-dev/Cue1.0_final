import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Cue/services/auth_provider.dart';

class MyPageOld extends StatefulWidget {
  @override
  _MyPageOldState createState() => _MyPageOldState();
}

class _MyPageOldState extends State<MyPageOld> {
  @override
  Widget build(BuildContext context) {
    final double mh = MediaQuery.of(context).size.height;
    final double mw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                title: Text(
                  'Cue!',
                  style: Theme.of(context).textTheme.headline2,
                ),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                      ),
                      onPressed: () {
                        context.read<AuthProvider>().signOut();
                      })
                ],
                centerTitle: true,
                expandedHeight: 230.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).accentColor,
                          radius: 50,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              '나나 nana (23)',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              '연기 취미생',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('구독자 수 1,452'),
                            Text('게시물 3'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    labelColor: Colors.black,
                    indicatorColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context).dividerColor,
                    tabs: [
                      Tab(text: "피드"),
                      Tab(text: "보관함"),
                      Tab(text: "스크랩"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[feedTab(mw, mh), storageTab(), scrapTab()],
          ),
        ),
      ),
    );
  }

  Widget feedTab(var mw, var mh) {
    List<String> url = [
      'https://pds.joins.com/news/component/htmlphoto_mmdata/202006/12/0befd24a-58a5-48bc-9bd5-3a07fbaf3077.jpg',
      'https://mimgnews.pstatic.net/image/438/2019/08/29/201908292597_20190829184741005.jpg?type=w540',
      'https://img.etnews.com/news/article/2018/02/02/cms_temp_article_02112847612319.jpg'
    ];
    List<String> title = ['급박한 상황, 약간의 액션..', '사랑, 남자친구와 함께 영..', '첫 연기 도전!'];

    return Container(
      color: Colors.grey[100],
      child: GridView.builder(
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: mw * 0.49,
              height: mh * 0.15,
              child: Column(
                children: [
                  Image.network(
                    url[index],
                    fit: BoxFit.fitHeight,
                  ),
                  Text(title[index])
                ],
              ),
            );
          }),
    );
  }

  Widget storageTab() {
    return Container(
      color: Colors.grey[100],
    );
  }

  Widget scrapTab() {
    return Container(
      color: Colors.grey[100],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
