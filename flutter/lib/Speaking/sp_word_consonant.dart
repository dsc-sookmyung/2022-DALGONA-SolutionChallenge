import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

import 'sp_word_select.dart';
import 'sp_practiceview_word.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class WordList {
  final String word;
  final int index;

  WordList(this.word, this.index);
}

class WordConsonantList {
  final String wordConsonant;
  final int index;

  WordConsonantList(this.wordConsonant, this.index);
}

class ChooseWordConsonantPage extends StatefulWidget {

  final List<WordConsonantList> wordConsonantList;

  const ChooseWordConsonantPage({Key? key, required this.wordConsonantList}) : super(key: key);

  @override
  _ChooseWordConsonantPageState createState() =>
      _ChooseWordConsonantPageState();
}

class _ChooseWordConsonantPageState extends State<ChooseWordConsonantPage> {
  int letterId = 0;
  String letter = 'ㄱ';

  final wordList = new List<WordList>.empty(growable: true);

  getGridViewSelectedItem(BuildContext context, String gridItem, int index) {
    letterInfo(gridItem, index + 1);
  }

  void letterInfo(String gridItem, int index) async {
    Map<String, String> _queryParameters = <String, String>{
      'onsetId': index.toString(),
      'onset': gridItem
    };

    var url =
        Uri.http('${serverHttp}:8080', '/speaking/list/word', _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      for (dynamic i in data) {
        String a = i["word"];
        int b = i["id"];
        wordList.add(WordList(a, b));
      }

      print("wordList: ${wordList}");
      // urlInfo(letter, letterId);

      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  WordSelectPage(consonant: gridItem, wordList: wordList)));
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        letterInfo(gridItem, index);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  void urlInfo(String letter, int letterId) async {
    Map<String, String> _queryParameters = <String, String>{
      'id': letterId.toString(),
    };

    var url = Uri.http(
        '${serverHttp}:8080', '/speaking/practice/letter', _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];

      print("url : ${url}");
      print("type : ${type}");
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        urlInfo(letter, letterId);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
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
                        "말하기 단어 연습",
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
                  // height: MediaQuery.of(context).size.height - 100,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Column(children: [
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: widget.wordConsonantList
                              .asMap()
                              .map((index, data) => MapEntry(
                                  index,
                                  GestureDetector(
                                      onTap: () {
                                        getGridViewSelectedItem(
                                            context, data.wordConsonant, index);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: (index / 3) % 2 < 1
                                                  ? Color(0xffD8EFFF)
                                                  : Color(0xff97D5FE),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          child: Center(
                                            child: Text(
                                              data.wordConsonant,
                                              style: TextStyle(
                                                  fontSize: 42,
                                                  color: Color(0xff333333),
                                                  fontWeight: FontWeight.w900),
                                              textAlign: TextAlign.center,
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
