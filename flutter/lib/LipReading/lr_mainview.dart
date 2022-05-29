import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:zerozone/Speaking/sp_practiceview_letter.dart';
import 'package:zerozone/Speaking/sp_practiceview_sentence.dart';
import 'package:zerozone/Speaking/sp_practiceview_word.dart';
import 'package:zerozone/custom_icons_icons.dart';
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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:zerozone/LipReading/practice/lr_letterview.dart';
import 'package:zerozone/LipReading/practice/lr_sentenceview.dart';
import 'package:zerozone/Speaking/sp_word_consonant.dart';
import 'package:zerozone/Speaking/sp_letter_consonant.dart';
import 'package:zerozone/Speaking/sp_select_situation.dart';
import 'package:zerozone/LipReading/test/lr_testinfo.dart';

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
  late var totalProbCnt;

  Future<void> letterRandomUrlInfo() async {


    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/letter/random');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      String letter = data["letter"];
      int letterId = data["letterId"];
      bool bookmarked = data["bookmarked"];

      print("url : ${url}");
      print("type : ${type}");


      //Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpLetterPracticePage(url: url, type: type, probId: probId, letter: letter, letterId: letterId, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        letterRandomUrlInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  Future<void> wordRandomUrlInfo() async {


    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/word/random');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      String word = data["word"];
      bool bookmarked = data["bookmarked"];

      print("url : ${url}");
      print("type : ${type}");


      //Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpWordPracticePage(url: url, type: type, probId: probId, word: word, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        wordRandomUrlInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  Future<void> sentenceRandomUrlInfo() async {


    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/sentence/random');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      String sentence = data["sentence"];
      bool bookmarked = data["bookmarked"];

      print("url : ${url}");
      print("type : ${type}");

      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpSentencePracticePage(url: url, type: type, probId: probId, sentence: sentence, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        sentenceRandomUrlInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

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

  _Cnt(String ver) async{
    var url;
    if(ver=='단어')
      url = Uri.http('${serverHttp}:8080', '/reading/test/word');
    else if(ver=='문장')
      url = Uri.http('${serverHttp}:8080', '/reading/test/sentence');
    else if(ver=='랜덤')
      url = Uri.http('${serverHttp}:8080', '/reading/test/random');
    else if(ver=='북마크')
      url = Uri.http('${serverHttp}:8080', '/reading/test/bookmark');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var data=body['data'];
      totalProbCnt=data['totalProbCount'];
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _Cnt(ver);
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
                    stops: [
                      0.3,
                      0.7,
                      0.9,
                    ],
                  ),
                ),

                child: SafeArea(
    child: Container(
                    child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 50.0,
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "학습하기",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 24,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height -160.0,
                    child: SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                        margin:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        // decoration: BoxDecoration(
                        //     color: Color(0xffF1EEE9),
                        //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                        // ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 0.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 20.0),
                              padding: EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: 220.0,
                              decoration: BoxDecoration(
                                color: Color(0xffF3F8FF),
                                border: Border.all(
                                    color: Color(0xff4478FF), width: 2.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Text(
                                "구화",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    LRChooseWordConsonantPage()));
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
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(2,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.wordpress_outlined,
                                              color: Color(0xff4478FF),
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
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    LrModeSentencePage()));
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
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(2,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.draw_rounded,
                                              color: Color(0xff4478FF),
                                              size: 90.0,
                                            ),
                                            Text(
                                              "문장",
                                              style: TextStyle(
                                                  color: Color(0xff333333),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _showModal("시험");
                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (_) => SelectSituationPage())
                                  // );
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  margin: EdgeInsets.only(
                                      left: 0.0,
                                      right: 15.0,
                                      top: 20.0,
                                      bottom: 15.0),
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(16.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
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
                                        CustomIcons.book,
                                        color: Color(0xff4478FF),
                                        size: 80.0,
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 5.0)),
                                      Text(
                                        "시험",
                                        style: TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 0.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 20.0),
                              padding: EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: 220.0,
                              decoration: BoxDecoration(
                                color: Color(0xffF3F8FF),
                                border: Border.all(
                                    color: Color(0xff4478FF), width: 2.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Text(
                                "말하기",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        _showModal("말하기 한 글자");
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
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(2,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.abc_outlined,
                                              color: Color(0xff4478FF),
                                              size: 90.0,
                                            ),
                                            Text(
                                              "한 글자",
                                              style: TextStyle(
                                                  color: Color(0xff333333),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      )),
                                  GestureDetector(
                                      onTap: () {
                                        _showModal("말하기 단어");
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
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(2,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.wordpress_outlined,
                                              color: Color(0xff4478FF),
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
                                      ))
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  _showModal("말하기 문장");
                                },
                                child: new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  margin: EdgeInsets.only(
                                      left: 0.0,
                                      right: 15.0,
                                      top: 20.0,
                                      bottom: 20.0),
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(16.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
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
                                        Icons.draw_rounded,
                                        color: Color(0xff4478FF),
                                        size: 90.0,
                                      ),
                                      Text(
                                        "문장",
                                        style: TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ])))));
  }

  void _showModal(String mode) {
    showMaterialModalBottomSheet(
        context: context,
        enableDrag : false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )
        ),
        backgroundColor: Color(0xffF3F4F6),
        builder: (context) => mode == "시험"
            ? Container(
                padding: EdgeInsets.only(top: 15.0),
                height: 170.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async{
                          Navigator.pop(context);
                          await _Cnt('단어');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => lrTestInfoPage(ver: '단어', cnt: totalProbCnt)));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width-10.0,
                          padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            )
                          ),

                          child: Center(
                              child: Text(
                            "단어",
                            style: TextStyle(
                                fontSize: 18.0, color: Color(0xff333333)),
                          )),
                        )),
                    Padding(padding: EdgeInsets.all(1.0)),
                    InkWell(
                      onTap: () async{
                        Navigator.pop(context);
                        await _Cnt('문장');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => lrTestInfoPage(ver: '문장', cnt: totalProbCnt)));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width-10.0,
                        padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,

                        ),
                        child: Center(
                            child: Text(
                          "문장",
                          style: TextStyle(
                              fontSize: 18.0, color: Color(0xff333333)),
                        )),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(1.0)),
                    InkWell(
                      onTap: () async{
                        Navigator.pop(context);
                        await _Cnt('랜덤');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => lrTestInfoPage(ver: '랜덤', cnt: totalProbCnt)));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width-10.0,
                        padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            )
                        ),
                        child: Center(
                            child: Text(
                          "랜덤",
                          style: TextStyle(
                              fontSize: 18.0, color: Color(0xff333333)),
                        )),
                      ),
                    ),
                  ],
                ),
              )
            : mode == "말하기 한 글자"
                ? Container(
                    padding: EdgeInsets.only(top: 15.0),
                    height: 120.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChooseConsonantPage()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width-10.0,
                              padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  )
                              ),
                              child: Center(
                                  child: Text(
                                "직접 선택",
                                style: TextStyle(
                                    fontSize: 18.0, color: Color(0xff333333)),
                              )),
                            )),
                        Padding(padding: EdgeInsets.all(1.0)),
                        InkWell(
                          onTap: () {
                            letterRandomUrlInfo();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width-10.0,
                            padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                )
                            ),
                            child: Center(
                                child: Text(
                              "랜덤",
                              style: TextStyle(
                                  fontSize: 18.0, color: Color(0xff333333)),
                            )),
                          ),
                        ),
                      ],
                    ),
                  )
                : mode == "말하기 단어"
                    ? Container(
                        padding: EdgeInsets.only(top: 15.0),
                        height: 120.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ChooseWordConsonantPage()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width-10.0,
                                  padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      )
                                  ),
                                  child: Center(
                                      child: Text(
                                    "직접 선택",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xff333333)),
                                  )),
                                )),
                            Padding(padding: EdgeInsets.all(1.0)),
                            InkWell(
                              onTap: () {
                                wordRandomUrlInfo();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width-10.0,
                                padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    )
                                ),
                                child: Center(
                                    child: Text(
                                  "랜덤",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Color(0xff333333)),
                                )),
                              ),
                            ),
                          ],
                        ),
                      )
                    : mode == "말하기 문장"
                        ? Container(
                            padding: EdgeInsets.only(top: 15.0),
                            height: 120.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  SelectSituationPage()));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width-10.0,
                                      padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          )
                                      ),
                                      child: Center(
                                          child: Text(
                                        "직접 선택",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff333333)),
                                      )),
                                    )),
                                Padding(padding: EdgeInsets.all(1.0)),
                                InkWell(
                                  onTap: () {
                                    sentenceRandomUrlInfo();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width-10.0,
                                    padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        )
                                    ),
                                    child: Center(
                                        child: Text(
                                      "랜덤",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xff333333)),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container());
  }
}
