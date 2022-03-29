library number_pagination;

import 'package:flutter/material.dart';
import 'lr_reviewlist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

class ReviewModePage extends StatefulWidget {
  final List testId;
  final List testName;
  final List correctCount;
  final List probCount;
  final List date;
  final int totalPage;
  final int totalElement;
  const ReviewModePage({Key? key, required this.totalPage, required this.totalElement, required this.testId, required this.testName, required this.correctCount, required this.probCount, required this.date});

  @override
  _ReviewModePageState createState() => _ReviewModePageState();
}

class _ReviewModePageState extends State<ReviewModePage> {
  onPageChanged(int pageNumber) {
    setState(() {
      pageInit = pageNumber;
    });
  }

  late List _dateList=widget.date;
  late List _testName=widget.testName;
  late List _testId=widget.testId;
  late List _correctCount=widget.correctCount;
  late List _probCount=widget.probCount;

  late int pageTotal=widget.totalPage==0?1:widget.totalPage;
  int pageInit = 1;
  late int threshold = pageTotal<5?
  pageTotal : 5;
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

  Future<void> _TestList(int page) async {
    _dateList.clear();
    _testName.clear();
    _correctCount.clear();
    _testId.clear();
    _probCount.clear();

    Map<String, String> _queryParameters = <String, String>{
      'page': page.toString()
    };
    var url = Uri.http('${serverHttp}:8080', '/reading/test/list', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data=body['data'];
      var _list=_data['content'];
      for(int i=0;i<_list.length;i++){
        DateTime date=DateTime.parse(_list[i]['date']);
        var day=(date.toString()).split(' ');
        setState(() {
          _dateList.add(day[0]);
          _testName.add(_list[i]['testName']);
          _correctCount.add(_list[i]['correctCount']);
          _testId.add(_list[i]['testId']);
          _probCount.add(_list[i]['probCount']);
        });
      }
      print('저장 완료');
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _TestList(page);
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

    rangeEnd=pageTotal<threshold
        ? pageTotal:
    rangeStart + threshold;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시험 기록',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(20.0)),
        Container(
            height: 570,
            child: Column(
              children: [
                ...List.generate(
                  _testName.length < 10 ? _testName.length : 10,
                      (idx) => Container(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async{
                        await _ProList(_testId[idx]);
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (_) => ReviewListPage(testId:_testId[idx],totalPage: _Page,totalElements: _Element,testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/${_probCount[idx]}',)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right:40, left:40),
                        padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey
                            ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_dateList[idx], style: TextStyle(fontSize: 13, color: Color(0xff333333)),),
                                  Padding(padding: EdgeInsets.only(top:4.0)),
                                  Text(_testName[idx],
                                    style: TextStyle(fontSize: 15, color: Color(0xff333333),
                                      ),
                                  ),
                                ]
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text(_testId[idx].toString(), style: TextStyle(fontSize: 13),),
                                Text('${_correctCount[idx]}/${_probCount[idx]}', style: TextStyle(fontSize: 17.0, color: Color(0xff333333)),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async{
                await _changePage(0);
                _TestList(currentPage);
              },
              child: iconToFirst,
            ),
            SizedBox(
              width: 4,
            ),
            InkWell(
                onTap: () async{
                  await _changePage(--currentPage);
                  _TestList(currentPage);
                } , child: iconPrevious),
            SizedBox(
              width: 10,
            ),
            ...List.generate(
              rangeEnd <= pageTotal ? threshold : pageTotal % threshold,
                  (index) => Flexible(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async{
                    await _changePage(index + 1 + rangeStart);
                    _TestList(currentPage);
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
                      ],
                    ),
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
            InkWell(onTap: () async{
              await _changePage(++currentPage);
              _TestList(currentPage);
            }, child: iconNext),
            SizedBox(
              width: 4,
            ),
            InkWell(onTap: () async{
              await _changePage(pageTotal);
              _TestList(currentPage);
            }, child: iconToLast),
          ],
        ),
        Padding(padding: EdgeInsets.all(15.0))
      ]),
    );
  }

  late List _type=[];
  late List _content=[];
  late List _correct=[];
  late List _testProbId=[];
  late int _Page;
  late int _Element;

  Future<void> _ProList(int id) async {
    _type.clear();
    _content.clear();
    _correct.clear();
    _testProbId.clear();

    Map<String, String> _queryParameters=<String,String>{
      'testId': id.toString()
    };

    var url = Uri.http('${server}:8080', '/reading/test/list/probs', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var _data=body['data'];
      var _list=_data['content'];
      _Page=_data['totalPages'];
      _Element=_data['totalElements'];
      for(int i=0;i<_list.length;i++){
        _type.add(_list[i]['type']);
        _testProbId.add(_list[i]['testProbId']);
        _content.add(_list[i]['content']);
        _correct.add(_list[i]['correct']);
      }
      print('저장 완료');
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _ProList(id);
        check = false;
      }
    }
  }
}
