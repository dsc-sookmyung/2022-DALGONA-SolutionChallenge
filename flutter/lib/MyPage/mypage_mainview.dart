import 'dart:ui';

import 'package:flutter/material.dart';
import '../Login/login.dart';

import 'mypage_bookmarklistview.dart';
import 'mypage_studylistview.dart';
import 'mypage_editinformationview.dart';


class MyPage extends StatelessWidget {

  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이 페이지',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),

      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0, left: 40.0, right: 40.0, bottom: 50.0),
              //padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 10.0),
              alignment: Alignment.center,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color(0xff5AA9DD),
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => ModifyInformationPage())
                        );
                      },
                      icon: Icon(Icons.edit),
                      iconSize: 20,
                    ),
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40.0, bottom: 30.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.black
                      )
                    ),
                    // child: Image.network(
                    //   "https://user-images.githubusercontent.com/61380136/152644132-fdcaff3b-d192-4513-853c-fb4f1516bdea.png",
                    //
                    // ),
                    height: 140,
                    // width: 150,
                  ),
                  Text(
                    "김도은",
                    style: TextStyle(fontSize: 24, height: 1.8, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "doeun536@gmail.com",
                    style: TextStyle(fontSize: 14, height: 1.8, fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
            Container(
              child: RaisedButton(
                child: new Text(
                  "학습 목록",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => StudyListPage())
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xffC8E8FF),
              ),
              width: 300,
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                child: new Text(
                  "책갈피 목록",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => BookMarkListPage())
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xffC8E8FF),
              ),
              width: 300,
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                    },
                    child: Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 12, decoration: TextDecoration.underline),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                    },
                    child: Text(
                      '회원탈퇴',
                      style: TextStyle(fontSize: 12, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
