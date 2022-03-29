import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerozone/Login/refreshToken.dart';
import '../Login/login.dart';

import 'mypage_bookmarklistview.dart';
import 'mypage_studylistview.dart';
import 'mypage_editinformationview.dart';
import 'mypage_lr_bookmark.dart';
import 'mypage_sp_bookmark.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/server.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  // const MyPage({Key? key}) : super(key: key);

  void userInfo() async {


    var url = Uri.http('${serverHttp}:8080', '/user/info');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      var data = body["data"];
      email = data["email"].toString();
      name = data["name"].toString();

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        userInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  late List _type=[];
  late List _content=[];
  late List _testProbId=[];
  late int _Page;
  late int _Element;

  Future<void> _SPList() async {
    _type.clear();
    _content.clear();
    _testProbId.clear();

    var url = Uri.http('${serverHttp}:8080', '/bookmark/speaking');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data=body['data'];
      var _list=_data['content'];

      if(_list.isEmpty){
        _Page=1;
        _Element=0;
      }
      else{
        _Page=_data['totalPages'];
        _Element=_data['totalElements'];
        for(int i=0;i<_list.length;i++){
          _type.add(_list[i]['type']);
          _testProbId.add(_list[i]['id']);
          _content.add(_list[i]['content']);
        }
      }

      print('저장 완료');

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SPBookmarkPage(totalPage: _Page, totalElements: _Element, type: _type, content: _content, testProbId: _testProbId))
      );
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _SPList();
        check = false;
      }
    }
  }

  late List _lrtype=[];
  late List _lrcontent=[];
  late List _lrtestProbId=[];
  late int _lrPage;
  late int _lrElement;

  Future<void> _LRList() async {
    _lrtype.clear();
    _lrcontent.clear();
    _lrtestProbId.clear();

    var url = Uri.http('${serverHttp}:8080', '/bookmark/reading');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data=body['data'];
      var _list=_data['content'];

      if(_list.isEmpty){
        _lrPage=1;
        _lrElement=0;
      }
      else{
        _lrPage=_data['totalPages'];
        _lrElement=_data['totalElements'];
        for(int i=0;i<_list.length;i++){
          _lrtype.add(_list[i]['type']);
          _lrtestProbId.add(_list[i]['id']);
          _lrcontent.add(_list[i]['content']);
        }
      }

      print('저장 완료');

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => LRBookmarkPage(totalPage: _lrPage, totalElements: _lrElement, type: _lrtype, content: _lrcontent, testProbId: _lrtestProbId))
      );
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _LRList();
        check = false;
      }
    }
  }


  @override
  void initState() {
    userInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     '마이 페이지',
      //     style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
      //   ),
      //   backgroundColor: Color(0xffC8E8FF),
      //
      // ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffe9f5ff),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 200.0, left: 40.0, right: 40.0, bottom: 80.0),
              //padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 10.0),
              alignment: Alignment.center,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xffE3F2FD),
                      Color(0xffBBDEFB),
                      Color(0xff90CAF9),
                    ],
                    stops: [0.2, 0.5, 0.9, ],
                ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                // border: Border.all(
                //   width: 2,
                //   color: Color(0xff5AA9DD),
                // ),
                borderRadius: BorderRadius.all(Radius.circular(15.0))
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => ModifyInformationPage())
                        ).then((value) {
                          _update(value);
                        });
                      },
                      icon: Icon(Icons.edit),
                      iconSize: 20,
                    ),
                    height: 20,
                  ),
                  Text(
                    "${name}",
                    style: TextStyle(fontSize: 32, height: 1.8, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${email}",
                    style: TextStyle(fontSize: 14, height: 1.8, fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
            Container(
              child: RaisedButton(
                child: new Text(
                  "구화 책갈피 목록",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  _LRList();
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
                  "말하기 책갈피 목록",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  _SPList();
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
                      //Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                      
                    },
                    child: Text(
                      '로그아웃',
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

  void _update(String value) { setState(() {
    name = value;
  }); }

}
