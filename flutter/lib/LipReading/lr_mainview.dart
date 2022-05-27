import 'package:flutter/material.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'practice/lr_practiceview.dart';
import 'lr_readvideo.dart';
import 'test/lr_testview.dart';
import 'package:flutter/services.dart';
import 'testReview/lr_reviewmode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'testReview/lr_reviewmode.dart';
import 'package:zerozone/server.dart';

class lrselectModeMainPage extends StatefulWidget {
  const lrselectModeMainPage({Key? key}) : super(key: key);

  @override
  _lrselectModeMainPageState createState() => _lrselectModeMainPageState();
}

class _lrselectModeMainPageState extends State<lrselectModeMainPage> {
  void letterBtnSelected() {
    print('button is clicked! ');
  }

  void sentenceBtnSelected() {
    //
  }
  late List _dateList = [];
  late List _testName = [];
  late List _correctCnt = [];
  late List _testId = [];
  late List _probCount = [];
  late int totalPage;
  late int totalElement;

  Future<void> _TestList() async {
    _dateList.clear();
    _testName.clear();
    _correctCnt.clear();
    _testId.clear();
    _probCount.clear();

    var url = Uri.http('${serverHttp}:8080', '/reading/test/list');

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data = body['data'];
      var _list = _data['content'];
      if (_list.isEmpty) {
        totalPage = 1;
        totalElement = 0;
      } else {
        totalPage = _data['totalPages'];
        totalElement = _data['totalElements'];
        for (int i = 0; i < _list.length; i++) {
          DateTime date = DateTime.parse(_list[i]['date']);
          var day = (date.toString()).split(' ');
          _dateList.add(day[0]);
          _testName.add(_list[i]['testName']);
          _correctCnt.add(_list[i]['correctCount']);
          _testId.add(_list[i]['testId']);
          _probCount.add(_list[i]['probCount']);
        }
      }
      print(_testId);
      print('저장 완료');
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _TestList();
        check = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "구화 연습",
        //     style: TextStyle(
        //         color: Color(0xff333333),
        //         fontSize: 24,
        //         fontWeight: FontWeight.w800),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: Color(0xffC8E8FF),
        // ),
        body: new Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: new Column(crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              "연습하기",
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),

                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                          width: 220.0,
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(
                                color: Color(0xff0074C8), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.ac_unit_outlined,
                                color: Color(0xff0074C8),
                              ),
                              Text(
                                "구화",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  print("Container clicked");
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(16.0),
                                    color: Color(0xffE8F9FD),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(
                                            2, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.ac_unit_outlined,
                                        color: Color(0xff2155CD),
                                        size: 90.0,
                                      ),
                                      Text(
                                        "단어",
                                        style: TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )),

                            GestureDetector(
                                onTap: (){
                                  print("Container clicked");
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xffE8F9FD),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(2, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.ac_unit_outlined,
                                        color: Color(0xff2155CD),
                                        size: 90.0,
                                      ),
                                      Text(
                                        "문장",
                                        style: TextStyle(
                                            color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
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
                          margin: EdgeInsets.only(
                              left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                          width: 220.0,
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(
                                color: Color(0xff0074C8), width: 2.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.ac_unit_outlined,
                                color: Color(0xff0074C8),
                              ),
                              Text(
                                "구화",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  print("Container clicked");
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                    new BorderRadius.circular(16.0),
                                    color: Color(0xffE8F9FD),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(
                                            2, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.ac_unit_outlined,
                                        color: Color(0xff2155CD),
                                        size: 90.0,
                                      ),
                                      Text(
                                        "단어",
                                        style: TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )),

                            GestureDetector(
                                onTap: (){
                                  print("Container clicked");
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Color(0xffE8F9FD),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: Offset(2, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.ac_unit_outlined,
                                        color: Color(0xff2155CD),
                                        size: 90.0,
                                      ),
                                      Text(
                                        "문장",
                                        style: TextStyle(
                                            color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )
                            )

                          ],
                        ),
                      ),


                      GestureDetector(
                          onTap: (){
                            print("Container clicked");
                          },
                          child: new Container(
                            width: 140.0,
                            height: 140.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Color(0xffE8F9FD),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: Offset(2, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.ac_unit_outlined,
                                  color: Color(0xff2155CD),
                                  size: 90.0,
                                ),
                                Text(
                                  "문장",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                      )

                    ],
                ),
            ),
        ));
  }
}
