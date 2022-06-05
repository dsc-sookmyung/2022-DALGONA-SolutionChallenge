import 'package:flutter/material.dart';
import 'package:zerozone/server.dart';
import 'lr_wordpractice.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';

class LRChooseWordConsonantPage extends StatefulWidget {
  const LRChooseWordConsonantPage({Key? key}) : super(key: key);

  @override
  _LRChooseWordConsonantPageState createState() =>
      _LRChooseWordConsonantPageState();
}

class _LRChooseWordConsonantPageState extends State<LRChooseWordConsonantPage> {
  List<String> consonantList = [
    'ㄱ',
    'ㄴ',
    'ㄷ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅅ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];

  getGridViewSelectedItem(BuildContext context, String gridItem, int index) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WordPracticePage(
                  onset: gridItem,
                  id: index + 1,
                  probId: _probId,
                  word: _word,
                  hint: _hint,
                  url: _url,
                  bookmarked: _bookmark,
              wordId: _wordId
                )));
  }

  var data;
  late var _word = "";
  late var _hint = "";
  late var _url = "";
  late bool _bookmark;
  late var _probId;
  late var _wordId;

  _randomWord(String onsetId, String onset) async {
    Map<String, String> _queryParameters = <String, String>{
      'onsetId': onsetId,
      'onset': onset
    };
    Uri.encodeComponent(onsetId);
    var url = Uri.http('${serverHttp}:8080', '/reading/practice/word/random',
        _queryParameters);

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
      _hint = data['hint'];
      _word = data['word'];
      _url = data['url'];
      _bookmark = data['bookmarked'];
      _probId = data['probId'];
      _wordId=data['wordId'];

    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _randomWord(onsetId, onset);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        iconSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      alignment: Alignment.center,
                      width: 300.0,
                      child: Text(
                        "구화 단어 연습",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
                  Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),

                              child: Column(
                                    children: [
                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          children: consonantList
                                              .asMap()
                                              .map((index, data) => MapEntry(
                                              index,
                                              GestureDetector(
                                                  onTap: () async {
                                                    await _randomWord(
                                                        (index + 1).toString(),
                                                        data);
                                                    getGridViewSelectedItem(
                                                        context, data, index);
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: (index / 3) % 2 < 1
                                                              ? Color(0xffD8EFFF)
                                                              : Color(0xff97D5FE),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0))),
                                                      child: Center(
                                                        child: Text(
                                                          data,
                                                          style: TextStyle(
                                                              fontSize: 42,
                                                              color:
                                                              Color(0xff333333),
                                                              fontWeight:
                                                              FontWeight.w900),
                                                          textAlign:
                                                          TextAlign.center,
                                                        ),
                                                      )))))
                                              .values
                                              .toList(),
                                        ),
                                      )
                                    ]),
                              ))
            ])))));
  }
}
