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


  updateYet(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '업데이트 예정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('추후 업데이트 될 예정입니다.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    userInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xffF3F4F6),
              Color(0xffEFF4FA),
              Color(0xffECF4FE),
            ],
            stops: [0.3, 0.7, 0.9, ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "마이페이지",
                        style: TextStyle(
                            color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                        ),
                      ),

                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(

                        child: Container(
                          margin: EdgeInsets.only(left: 40.0, right: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0, bottom: 25.0),
                                //padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0, bottom: 10.0),
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color(0xffFFFFFF),
                                        Color(0xffE3F2FD),
                                        Color(0xffBBDEFB),
                                      ],
                                      stops: [0.1, 0.3, 0.8, ],
                                    ),
                                    // border: Border.all(
                                    //     color: Color(0xff999999),
                                    //     width: 1.0
                                    // ),
                                    color: Color(0xffFFFFFF),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(2, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,

                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 40.0),
                                          child: Text(
                                            "${name}",
                                            style: TextStyle(fontSize: 32, height: 1.8, fontWeight: FontWeight.w700),
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(bottom: 10.0),
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
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 40.0),
                                      child: Text(
                                        "${email}",
                                        style: TextStyle(fontSize: 14, height: 1.8, fontWeight: FontWeight.w200),
                                      ),
                                    )

                                  ],
                                ),
                              ),

                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                                width: 150.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff4478FF),
                                      width: 2.0
                                  ),
                                  color: Color(0xffF3F8FF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.9),
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(1, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)
                                  ),
                                ),
                                child: Text("최근 학습",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                              ),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: (){
                                          // 구화 최근 학습
                                          updateYet();
                                        },
                                        child: new Container(
                                          width: 140.0,
                                          height: 130.0,
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(16.0),
                                            color: Color(0xffFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.9),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: Offset(2, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.face,
                                                color: Color(0xff4478FF),
                                                size: 70.0,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  "구화 연습",
                                                  style: TextStyle(
                                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ),

                                    GestureDetector(
                                        onTap: (){
                                          // 말하기 최근 학습
                                          updateYet();
                                        },
                                        child: new Container(
                                          width: 140.0,
                                          height: 130.0,
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(16.0),
                                            color: Color(0xffFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.9),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: Offset(2, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.record_voice_over,
                                                color: Color(0xff4478FF),
                                                size: 70.0,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  "말하기 연습",
                                                  style: TextStyle(
                                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    )

                                  ],
                                ),
                              ),



                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 35.0, bottom: 20.0),
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                                width: 150.0,
                                decoration: BoxDecoration(
                                  color: Color(0xffF3F8FF),
                                  border: Border.all(
                                      color: Color(0xff4478FF),
                                      width: 2.0
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.9),
                                      spreadRadius: 0,
                                      blurRadius: 2,
                                      offset: Offset(1, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20.0)
                                  ),
                                ),
                                child: Text("북마크",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                              ),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: (){
                                          _LRList();
                                        },
                                        child: new Container(
                                          width: 140.0,
                                          height: 130.0,
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(16.0),
                                            color: Color(0xffFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.9),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: Offset(2, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.face,
                                                color: Color(0xff4478FF),
                                                size: 70.0,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  "구화 연습",
                                                  style: TextStyle(
                                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ),

                                    GestureDetector(
                                        onTap: (){
                                          _SPList();
                                        },
                                        child: new Container(
                                          width: 140.0,
                                          height: 130.0,
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.circular(16.0),
                                            color: Color(0xffFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.9),
                                                spreadRadius: 0,
                                                blurRadius: 5,
                                                offset: Offset(2, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.record_voice_over,
                                                color: Color(0xff4478FF),
                                                size: 70.0,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  "말하기 연습",
                                                  style: TextStyle(
                                                      color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    )

                                  ],
                                ),
                              ),

                              Container(
                                  margin: EdgeInsets.only(top: 30.0),
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
                        )
                    ),
                  )

              )
            ],
          ),
        )
      )
    );

  }

  void _update(String value) { setState(() {
    name = value;
  }); }

}
