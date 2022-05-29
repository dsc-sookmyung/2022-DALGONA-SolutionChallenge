import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lr_sentencepractice.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

class LrModeSentencePage extends StatefulWidget {
  const LrModeSentencePage({Key? key}) : super(key: key);

  @override
  _LrModeSentencePageState createState() => _LrModeSentencePageState();
}

class _LrModeSentencePageState extends State<LrModeSentencePage> {
  var data;
  late String _space;
  late var _sentence;
  late var _hint;
  late var _url;
  late var _probId;
  late var _bookmarked;

  _randomsentence(String situationId, String situation) async {
    _space = "";
    Map<String, String> _queryParameters = <String, String>{
      'situationId': situationId,
      'situation': situation
    };
    // Uri.encodeComponent(situationId);
    var url = Uri.http('${serverHttp}:8080',
        '/reading/practice/sentence/random', _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });
    print(url);
    // print("Bearer $authToken");
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      data = body["data"];
      // print(data);

      var repeat = data['spacingInfo'].split("");
      for (int i = 0; i < repeat.length; i++) {
        _space += "_ " * int.parse(repeat[i]);
        _space += " ";
      }
      setState(() {
        _space;
        _sentence = data['sentence'];
        _hint = data['hint'];
        _url = data['url'];
        _probId = data['probId'];
        _bookmarked = data['bookmarked'];
      });
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _randomsentence(situationId, situation);
        check = false;
      }
    }
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
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "구화 문장 연습",
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
                      "상황 선택하기",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                        Container(
                          width: MediaQuery.of(context).size.width -50.0,
                          height: MediaQuery.of(context).size.width *0.2,
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
                          child: new RaisedButton(
                              color: Color(0xffD8EFFF),
                              child: new Text(
                                '인사하기',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () async {
                                await _randomsentence('1', '인사하기');
                                Navigator.of(context).pop();
                                // print('확인: '+_sentence+' '+_space+' '+_hint+' '+_url);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SentencePracticePage(
                                              id: 1,
                                              situation: '인사하기',
                                              probId: _probId,
                                              sentence: _sentence,
                                              space: _space,
                                              hint: _hint,
                                              url: _url,
                                              bookmarked: _bookmarked,
                                            )));
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                          child: new RaisedButton(
                              color: Color(0xff97D5FE),
                              child: new Text(
                                '날짜와 시간 말하기',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () async {
                                await _randomsentence('2', '날짜와 시간 말하기');
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SentencePracticePage(
                                              id: 2,
                                              situation: '날짜와 시간 말하기',
                                              probId: _probId,
                                              sentence: _sentence,
                                              space: _space,
                                              hint: _hint,
                                              url: _url,
                                              bookmarked: _bookmarked,
                                            )));
                              }),
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                          child: new RaisedButton(
                              color: Color(0xffD8EFFF),
                              child: new Text(
                                '날씨 말하기',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () async {
                                await _randomsentence('3', '날씨 말하기');
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SentencePracticePage(
                                              id: 3,
                                              situation: '날씨 말하기',
                                              probId: _probId,
                                              sentence: _sentence,
                                              space: _space,
                                              hint: _hint,
                                              url: _url,
                                              bookmarked: _bookmarked,
                                            )));
                              }),
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                          child: new RaisedButton(
                              color: Color(0xff97D5FE),
                              child: new Text(
                                '부탁 요청하기',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () async {
                                await _randomsentence('4', '부탁 요청하기');
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SentencePracticePage(
                                              id: 4,
                                              situation: '부탁 요청하기',
                                              probId: _probId,
                                              sentence: _sentence,
                                              space: _space,
                                              hint: _hint,
                                              url: _url,
                                              bookmarked: _bookmarked,
                                            )));
                              }),
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                          margin: EdgeInsets.only(
                              left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                          child: new RaisedButton(
                              color: Color(0xffD8EFFF),
                              child: new Text(
                                '기분 표현하기',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w500),
                              ),
                              onPressed: () async {
                                await _randomsentence('5', '기분 표현하기');
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SentencePracticePage(
                                              id: 5,
                                              situation: '기분 표현하기',
                                              probId: _probId,
                                              sentence: _sentence,
                                              space: _space,
                                              hint: _hint,
                                              url: _url,
                                              bookmarked: _bookmarked,
                                            )));
                              }),
                          height: 40,
                        ),
                      ],
                    ),
                  )));
  }
}
