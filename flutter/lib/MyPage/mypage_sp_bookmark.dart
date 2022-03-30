library number_pagination;

import 'package:flutter/material.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/maki_icons.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/web_symbols_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

import '../Speaking/sp_practiceview_letter.dart';
import '../Speaking/sp_practiceview_word.dart';
import '../Speaking/sp_practiceview_sentence.dart';

class SPBookmarkPage extends StatefulWidget {
  const SPBookmarkPage(
      {Key? key,
        required this.totalPage,
        required this.totalElements,
        required this.type,
        required this.content,
        required this.testProbId,
      });
  final int totalPage, totalElements;
  final List type, content, testProbId;

  @override
  _SPBookmarkPageState createState() => _SPBookmarkPageState();
}

class _SPBookmarkPageState extends State<SPBookmarkPage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }

  late List _testProbId = widget.testProbId;
  late List _type = widget.type;
  late List _content = widget.content;

  late int pageTotal = widget.totalPage;
  int pageInit = 1;
  late int threshold = pageTotal < 5 ? pageTotal : 5;
  Color colorPrimary = Colors.black;
  Color colorSub = Colors.white;
  late Widget iconToFirst;
  late Widget iconPrevious;
  late Widget iconNext;
  late Widget iconToLast;
  double fontSize = 15;
  String? fontFamily;

  late int rangeStart;
  late int rangeEnd;
  late int currentPage;

  Future<void> _ProList(int page) async {
    _type.clear();
    _content.clear();
    _testProbId.clear();

    Map<String, String> _queryParameters = <String, String>{
      'page': page.toString()
    };

    var url =
    Uri.http('${serverHttp}:8080', '/bookmark/speaking', _queryParameters);

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

      for (int i = 0; i < _list.length; i++) {
        setState(() {
          _type.add(_list[i]['type']);
          _testProbId.add(_list[i]['id']);
          _content.add(_list[i]['content']);
        });
      }
      print('저장 완료');
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _ProList(page);
        check = false;
      }
    }
  }

  @override
  void initState() {
    currentPage = pageInit;
    iconToFirst = Icon(Icons.first_page, color:Color(0xff5AA9DD));
    iconPrevious = Icon(Icons.keyboard_arrow_left, color:Color(0xff5AA9DD));
    iconNext = Icon(Icons.keyboard_arrow_right, color:Color(0xff5AA9DD));
    iconToLast = Icon(Icons.last_page, color:Color(0xff5AA9DD));

    _rangeSet();

    super.initState();
  }

  _changePage(int page) {
    if (page <= 0) page = 1;

    if (page > pageTotal) page = pageTotal;

    setState(() {
      currentPage = page;
      _rangeSet();
      onPageChanged(currentPage);
    });
  }

  void _rangeSet() {
    rangeStart = currentPage % threshold == 0
        ? currentPage - threshold
        : (currentPage ~/ threshold) * threshold;

    rangeEnd = pageTotal < threshold ? pageTotal : rangeStart + threshold;
  }

  Future<void> practiceSpeaking(int idx) async {

    late var url;

    Map<String, String> _queryParameters = <String, String>{
      'id': _testProbId[idx].toString(),
    };

    if(_type[idx] == 'Word'){
      url = Uri.http('${serverHttp}:8080', '/speaking/practice/word', _queryParameters);
    }
    else if(_type[idx] == 'Sentence'){
      url = Uri.http('${serverHttp}:8080', '/speaking/practice/sentence', _queryParameters);
    }
    else if(_type[idx] == 'Letter'){
      url = Uri.http('${serverHttp}:8080', '/speaking/practice/letter', _queryParameters);
    }

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      bool bookmarked = data["bookmarked"];

      if(_type[idx] == 'Word'){
        String word = data["word"];
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SpWordPracticePage(url: url, type: type, probId: probId, word: word, bookmarked: bookmarked,))
        );
      }
      else if(_type[idx] == 'Sentence'){

        String sentence = data["sentence"];

        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SpSentencePracticePage(url: url, type: type, probId: probId, sentence: sentence, bookmarked: bookmarked,))
        );
      }
      else if(_type[idx] == 'Letter'){

        String letter = data["letter"];
        int letterId = data["letterId"];

        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SpLetterPracticePage(letter: letter, letterId: letterId, url: url, type: type, probId: probId, bookmarked: bookmarked,))
        );
      }

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        practiceSpeaking(idx);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '말하기 책갈피 목록',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 24,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: new Container(
    color: Color(0xfff0f8ff),
    child:
    Column(children: [
        Padding(padding: EdgeInsets.only(top:50.0, left: 20.0, right: 20.0)),
        Container(
            height: 560,
            child: Column(
              children: [
                ...List.generate(
                  _content.length < 10 ? _content.length : 10,
                      (idx) => Container(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        practiceSpeaking(idx);
                        // await _ProList(idx);
                        // Navigator.push(
                        //     context, MaterialPageRoute(
                        //     builder: (_) => ReviewListPage2(totalPage: _Page,totalElements: _Element,testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/10',)));
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 40, left: 40),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blueGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if(_type[idx]=='Word')
                              Container(
                                child: Text('단어'+ ' - ' + _content[idx],
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff333333)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            else
                              Container(
                                child: Text(_type[idx]=='Letter'?'한 글자'+ ' - ' + _content[idx]
                                    :'문장'+ ' - ' + _content[idx],
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff333333)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await _changePage(0);
                _ProList(currentPage);
              },
              child: iconToFirst,
            ),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () async {
                  await _changePage(--currentPage);
                  _ProList(currentPage);
                },
                child: iconPrevious),
            SizedBox(
              width: 10,
            ),
            ...List.generate(
              rangeEnd <= pageTotal ? threshold : pageTotal % threshold,
                  (index) => Flexible(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await _changePage(index + 1 + rangeStart);
                    _ProList(currentPage);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: (currentPage - 1) % threshold == index
                            ? Color(0xff5AA9DD)
                            : colorSub,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 3.0,
                          ),
                        ]),
                    child: Text(
                      '${index + 1 + rangeStart}',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        color: (currentPage - 1) % threshold == index
                            ? colorSub
                            : colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () async {
                  await _changePage(++currentPage);
                  _ProList(currentPage);
                },
                child: iconNext),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () async {
                  await _changePage(pageTotal);
                  _ProList(currentPage);
                },
                child: iconToLast),
          ],
        ),
        Padding(padding: EdgeInsets.all(15.0))
      ]),
    ));
  }
}
