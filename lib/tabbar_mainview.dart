import 'package:flutter/material.dart';

import 'Speaking/selectmode_mainview.dart';
import 'LipReading/lrselectmode_mainview.dart';
import 'MyPage/mypage_mainview.dart';


class tabBarMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '구화 연습하기',
      home: BottomNavigator(),
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigatorState();
  }
}

class _BottomNavigatorState extends State<BottomNavigator> with SingleTickerProviderStateMixin {

  int _seletedIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _seletedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _widgetOptions = [
    lrselectModeMainPage(),
    selectModeMainPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            icon: _seletedIndex == 0 ? Icon(Icons.face) : Icon(Icons.face_outlined),
            text: '읽기',
          ),
          Tab(
            icon: _seletedIndex == 1 ? Icon(Icons.record_voice_over) : Icon(Icons.record_voice_over_outlined),
            text: '말하기',
          ),
          Tab(
            icon: _seletedIndex == 2? Icon(Icons.home_filled) : Icon(Icons.home_outlined),
            text: '쓰기',
          ),
        ],
        indicatorColor: Colors.transparent,
      ),
      body: TabBarView(
        controller: _tabController,
        children: _widgetOptions,
      ),

    );
  }
}
