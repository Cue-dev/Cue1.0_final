// import 'package:Cue/screen/Cam/cue_ready.dart';
import 'package:Cue/screen/MyPage/my_page.dart';
import 'package:Cue/screen/video/playlist_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            PlayListPage(),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.orange,
            ),
            // CloudStorageDemo(),
            Container(
              color: Colors.yellow,
            ),
            MyPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        elevation: 5.0,
        backgroundColor: Colors.white.withOpacity(.90),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '홈',
            icon: ImageIcon(
              AssetImage('icons/홈.png'),
            ),
          ),
          BottomNavigationBarItem(
              label: '검색', icon: ImageIcon(AssetImage('icons/검색.png'))),
          BottomNavigationBarItem(
              label: '구독', icon: ImageIcon(AssetImage('icons/구독.png'))),
          BottomNavigationBarItem(
              label: '알림', icon: ImageIcon(AssetImage('icons/알림.png'))),
          BottomNavigationBarItem(
              label: '마이', icon: ImageIcon(AssetImage('icons/마이.png'))),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    });
  }
}
