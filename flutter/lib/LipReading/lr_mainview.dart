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
  late List _dateList=[];
  late List _testName=[];
  late List _correctCnt=[];
  late List _testId=[];
  late List _probCount=[];
  late int totalPage;
  late int totalElement;

  Future<void> _TestList() async {
    _dateList.clear();
    _testName.clear();
    _correctCnt.clear();
    _testId.clear();
    _probCount.clear();

    var url = Uri.http('${serverHttp}:8080', '/reading/test/list');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data=body['data'];
      var _list=_data['content'];
      if(_list.isEmpty){
        totalPage=1;
        totalElement=0;
      }
      else{
        totalPage=_data['totalPages'];
        totalElement=_data['totalElements'];
        for(int i=0;i<_list.length;i++){
          DateTime date=DateTime.parse(_list[i]['date']);
          var day=(date.toString()).split(' ');
          _dateList.add(day[0]);
          _testName.add(_list[i]['testName']);
          _correctCnt.add(_list[i]['correctCount']);
          _testId.add(_list[i]['testId']);
          _probCount.add(_list[i]['probCount']);
      }
      }
      print(_testId);
      print('저장 완료');
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
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
        //         color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: Color(0xffC8E8FF),
        // ),
        body: new Container(
          decoration: BoxDecoration(
          color: Color(0xffe9f5ff),
          ),
          padding: EdgeInsets.only(top: 190.0),
          // margin: EdgeInsets.only(top: 130.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new Icon(
                  Icons.face,
                  color: Color(0xff5AA9DD),
                  size: 180.0,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(
                    left: 0.0, top: 40.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffC8E8FF),
                    child: new Text(
                      '연습하기',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w500),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => lrselectModeWordPage()));
                    }),
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(
                    left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffC8E8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: new Text(
                      '시험 보기',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => lrTestModePage()));
                    }),
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(
                    left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffC8E8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: new Text(
                      '시험 목록 보기',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w500),
                    ),
                    onPressed: () async{
                      await _TestList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReviewModePage(totalPage: totalPage, totalElement: totalElement, testId: _testId,testName: _testName,correctCount: _correctCnt,probCount:_probCount,date: _dateList,)));
                    }),
                height: 40,
              ),
              // Container(
              //   padding: EdgeInsets.only(
              //       left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              //   margin: EdgeInsets.only(
              //       left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
              //   child: new RaisedButton(
              //       color: Color(0xffC8E8FF),
              //       child: new Text(
              //         '영상으로 연습하기',
              //         style: new TextStyle(
              //             fontSize: 20.0,
              //             color: Color(0xff333333),
              //             fontWeight: FontWeight.w500),
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (_) => ReadingVideo()));
              //       }),
              //   height: 40,
              // ),
            ],
          ),
        ));
  }
}
