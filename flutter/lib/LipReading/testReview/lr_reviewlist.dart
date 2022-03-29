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

class ReviewListPage extends StatefulWidget {
  const ReviewListPage(
      {Key? key,
      required this.testId,
      required this.totalPage,
      required this.totalElements,
      required this.testProbId,
      required this.type,
      required this.content,
      required this.correct,
      required this.date,
      required this.title,
      required this.score});
  final String date, title, score;
  final int testId, totalPage, totalElements;
  final List testProbId, type, content, correct;

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }

  late List _testProbId = widget.testProbId;
  late List _type = widget.type;
  late List _content = widget.content;
  late List _correct = widget.correct;

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

  Future<void> _ProList(int id, int page) async {
    _type.clear();
    _content.clear();
    _correct.clear();
    _testProbId.clear();

    Map<String, String> _queryParameters = <String, String>{
      'testId': id.toString(),
      'page': page.toString()
    };

    var url =
        Uri.http('104.197.249.40:8080', '/reading/test/list/probs', _queryParameters);

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
          _testProbId.add(_list[i]['testProbId']);
          _content.add(_list[i]['content']);
          _correct.add(_list[i]['correct']);
        });
      }
      print('저장 완료');
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _ProList(id, page);
        check = false;
      }
    }
  }

  @override
  void initState() {
    currentPage = pageInit;
    iconToFirst = Icon(Icons.first_page);
    iconPrevious = Icon(Icons.keyboard_arrow_left);
    iconNext = Icon(Icons.keyboard_arrow_right);
    iconToLast = Icon(Icons.last_page);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '기록 확인',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 24,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(20.0)),
        Container(
            height: 560,
            child: Column(
              children: [
                Container(
                  height: 75,
                  margin: EdgeInsets.only(right: 40.0, left: 40.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.3, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.date}',
                              style: TextStyle(fontSize: 13),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Text(
                              '${widget.title}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.score}',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    color: Color(0xffC8E8FF),
                  ),
                ),
                ...List.generate(
                  _content.length < 10 ? _content.length : 10,
                  (idx) => Container(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        // await _ProList(idx);
                        // Navigator.push(
                        //     context, MaterialPageRoute(
                        //     builder: (_) => ReviewListPage2(totalPage: _Page,totalElements: _Element,testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/10',)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 40, left: 40),
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(_type[idx]=='Word'?'단어'+ ' - ' + _content[idx]
                                  :'문장'+ ' - ' + _content[idx],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff333333)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              child: Icon(
                                _correct[idx] ? CustomIcons.check : Icons.clear,
                                color: _correct[idx] ? Colors.green : Colors.red,
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
                _ProList(widget.testId, currentPage);
              },
              child: iconToFirst,
            ),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () async {
                  await _changePage(--currentPage);
                  _ProList(widget.testId, currentPage);
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
                    _ProList(widget.testId, currentPage);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: (currentPage - 1) % threshold == index
                            ? colorPrimary
                            : colorSub,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
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
                  _ProList(widget.testId, currentPage);
                },
                child: iconNext),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () async {
                  await _changePage(pageTotal);
                  _ProList(widget.testId, currentPage);
                },
                child: iconToLast),
          ],
        ),
        Padding(padding: EdgeInsets.all(15.0))
      ]),
    );
  }
}
