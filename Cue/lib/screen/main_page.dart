// import 'package:Cue/screen/Cam/cue_ready.dart';
import 'package:Cue/screen/MyHomePage.dart';
import 'package:Cue/screen/MyPage/my_page.dart';
import 'package:Cue/screen/video/playlist_page.dart';
import 'package:flutter/material.dart';
import 'package:Cue/screen/popular_page.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(children: [
        SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: <Widget>[
              PlayListPage(),
              PopularPage(),
              // MyHomePage(),
              Container(
                color: Colors.orange,
              ),
              //CloudStorageDemo(),
              Container(
                color: Colors.yellow,
              ),
              MyPage(),
            ],
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: bottomNavigationBar)
      ]),
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
