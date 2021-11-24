// import 'package:Cue/screen/Cam/cue_ready.dart';
import 'package:Cue/screen/dialog/ready_dialog.dart';
import 'package:Cue/screen/MyHomePage.dart';
import 'package:Cue/screen/MyPage/my_page.dart';
import 'package:Cue/screen/dialog/cue_dialog.dart';
import 'package:Cue/screen/feed_page.dart';
import 'package:Cue/screen/video/playlist_page.dart';
import 'package:Cue/screen/video/uploadvideo_page.dart';
import 'package:flutter/material.dart';
import 'package:Cue/screen/popular_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: PlayListPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: IconButton(
      //   icon: ImageIcon(AssetImage('icons/큐.png')),
      //   iconSize: 50,
      //   onPressed: () {
      //     _onCueButtonTapped();
      //   },
      // ),
      // body: Stack(children: [
      //   SizedBox.expand(
      //     child: PageView(
      //       controller: _pageController,
      //       onPageChanged: (index) {
      //         setState(() {
      //           _selectedIndex = index;
      //         });
      //       },
      //       children: <Widget>[
      //         PlayListPage(),
      //         PopularPage(),
      //         Container(
      //           color: Colors.black,
      //         ),
      //         FeedPage(),
      //         MyPage(),
      //       ],
      //     ),
      //   ),
      //   Positioned(left: 0, right: 0, bottom: 0, child: bottomNavigationBar),
      // ]),
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
      child: BottomNavigationBar(
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        unselectedItemColor: Theme.of(context).secondaryHeaderColor,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '홈',
            icon: ImageIcon(
              AssetImage('icons/홈.png'),
            ),
          ),
          BottomNavigationBarItem(
              label: '인기',
              icon: ImageIcon(
                AssetImage('icons/인기.png'),
              )),
          BottomNavigationBarItem(
              label: '큐', icon: ImageIcon(AssetImage('icons/큐.png'))),
          BottomNavigationBarItem(
              label: '피드', icon: ImageIcon(AssetImage('icons/피드.png'))),
          BottomNavigationBarItem(
              label: '마이', icon: ImageIcon(AssetImage('icons/마이.png'))),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) =>
            index != 2 ? _onItemTapped(index) : _onCueButtonTapped(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController!.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    });
  }

  void _onCueButtonTapped() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final double mh = MediaQuery.of(context).size.height;
        final double mw = MediaQuery.of(context).size.width;

        return Dialog(
            insetPadding: EdgeInsets.only(top: mh * 0.7),
            child: Padding(
              padding: EdgeInsets.all(mh * 0.015),
              child: Column(
                children: [
                  InkWell(
                    child: _buildDialogButtons(
                        mw, mh, 'icons/라이브러리.png', '라이브러리에서 영상 선택하기'),
                    onTap: () {},
                  ),
                  InkWell(
                    child:
                        _buildDialogButtons(mw, mh, 'icons/큐.png', '지금 바로 큐하기'),
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
