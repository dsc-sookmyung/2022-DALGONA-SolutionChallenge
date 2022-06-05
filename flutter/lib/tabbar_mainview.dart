import 'package:flutter/material.dart';

import 'LipReading/lr_mainview.dart';
import 'MyPage/mypage_mainview.dart';
import 'Custom/customMainPage.dart';


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
    customMainPageView(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: TabBar(

          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: _seletedIndex == 0 ? Icon(Icons.face, color: Color(0xff4478FF)) : Icon(Icons.face_outlined, color: Color(0xff4478FF)),
              child: Text(
                '학습하기',
                style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
              ),
            ),
            Tab(
              icon: _seletedIndex == 1 ? Icon(Icons.add_box_rounded, color: Color(0xff4478FF)) : Icon(Icons.add_box_outlined, color: Color(0xff4478FF)),
              child: Text(
                '커스텀',
                style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
              ),
            ),
            Tab(
              icon: _seletedIndex == 2? Icon(Icons.home_filled, color: Color(0xff4478FF),) : Icon(Icons.home_outlined, color: Color(0xff4478FF)),
              child: Text(
                '마이페이지',
                style: TextStyle(color: Color(0xff4478FF), fontSize: 11),
              ),
            ),
          ],
          indicatorColor: Colors.transparent,
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: _widgetOptions,
        ),
      )


    );
  }
}
