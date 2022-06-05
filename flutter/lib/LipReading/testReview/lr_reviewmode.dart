library number_pagination;

import 'package:flutter/material.dart';
import 'lr_reviewlist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';
import 'package:card_swiper/card_swiper.dart';

import 'lr_reviewlist.dart';

class ReviewModePage extends StatefulWidget {
  final List testId;
  final List testName;
  final List correctCount;
  final List probCount;
  final List date;
  final int totalPage;
  final int totalElement;
  const ReviewModePage(
      {Key? key,
      required this.totalPage,
      required this.totalElement,
      required this.testId,
      required this.testName,
      required this.correctCount,
      required this.probCount,
      required this.date});

  @override
  _ReviewModePageState createState() => _ReviewModePageState();
}

class _ReviewModePageState extends State<ReviewModePage> {
  late List _dateList = widget.date;
  late List _testName = widget.testName;
  late List _testId = widget.testId;
  late List _correctCount = widget.correctCount;
  late List _probCount = widget.probCount;

  late int pageTotal = widget.totalElement % 10 == 0
      ? widget.totalElement ~/ 10
      : widget.totalElement ~/ 10 + 1;
  int _curPage = 1;

  double fontSize = 15;
  String? fontFamily;

  // Future<void> _TestList(int page) async {
  //   _dateList.clear();
  //   _testName.clear();
  //   _correctCount.clear();
  //   _testId.clear();
  //   _probCount.clear();
  //
  //   Map<String, String> _queryParameters = <String, String>{
  //     'page': page.toString()
  //   };
  //   var url =
  //       Uri.http('${serverHttp}:8080', '/reading/test/list', _queryParameters);
  //
  //   var response = await http.get(url, headers: {
  //     'Accept': 'application/json',
  //     "content-type": "application/json",
  //     "Authorization": "Bearer $authToken"
  //   });
  //   print(url);
  //   print('Response status: ${response.statusCode}');
  //
  //   if (response.statusCode == 200) {
  //     print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
  //     var body = jsonDecode(utf8.decode(response.bodyBytes));
  //     var _data = body['data'];
  //     var _list = _data['content'];
  //     for (int i = 0; i < _list.length; i++) {
  //       DateTime date = DateTime.parse(_list[i]['date']);
  //       var day = (date.toString()).split(' ');
  //       setState(() {
  //         _dateList.add(day[0]);
  //         _testName.add(_list[i]['testName']);
  //         _correctCount.add(_list[i]['correctCount']);
  //         _testId.add(_list[i]['testId']);
  //         _probCount.add(_list[i]['probCount']);
  //       });
  //     }
  //     print('저장 완료');
  //   } else if (response.statusCode == 401) {
  //     await RefreshToken(context);
  //     if (check == true) {
  //       _TestList(page);
  //       check = false;
  //     }
  //   }
  // }

  Future<void> _ProList(int id) async {
    _type.clear();
    _content.clear();
    _correct.clear();
    _testProbId.clear();

    Map<String, String> _queryParameters = <String, String>{
      'testId': id.toString()
    };

    var url = Uri.http(
        '${serverHttp}:8080', '/reading/test/list/probs', _queryParameters);

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
        _type.add(_list[i]['type']);
        _testProbId.add(_list[i]['testProbId']);
        _content.add(_list[i]['content']);
        _correct.add(_list[i]['correct']);
      }
      print('저장 완료');
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _ProList(id);
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
                      width: 300.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "시험 기록",
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
                child: Swiper(
                  loop: false,
                  itemBuilder: (BuildContext context, int idx) {
                    return (Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            ...List.generate(
                              _curPage == pageTotal
                                  ? widget.totalElement - (_curPage - 1) * 10
                                  : 10,
                              (idx) => Container(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await _ProList(_testId[idx+10*(_curPage-1)]);
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (_) => ReviewListPage(testId: idx+10*(_curPage-1),testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/10',)));
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        6.7 /
                                        100,
                                    margin: EdgeInsets.only(
                                      right: 50,
                                      left: 50,
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                      // border: Border.all(
                                      //     width: 2, color: Color(0xff4478FF)
                                      //     //     left: BorderSide(
                                      //     //       color: _type[idx+10*(_curPage-1)] == "Word" ? Color(0xff2D31FA) : (_type[idx+10*(_curPage-1)] == "Sentence" ? Color(0xff161D6E) : Color(0xff00BBF0)),
                                      //     //       width: 5.0,
                                      //     //     ),
                                      //     //     right: BorderSide(
                                      //     //       color: Colors.black,
                                      //     //       width: 1.0,
                                      //     //     ),
                                      //     //     top: BorderSide(
                                      //     //       color: Colors.black,
                                      //     //       width: 1.0,
                                      //     //     ),
                                      //     //     bottom: BorderSide(
                                      //     //       color: Colors.black,
                                      //     //       width: 1.0,
                                      //     //     )
                                      //     ),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.9),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: Offset(2,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _dateList[idx+10*(_curPage-1)],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999)),
                                              ),
                                              // Padding(
                                              //     padding: EdgeInsets.only(
                                              //         top: 1.0)),
                                              Text(
                                                _testName[idx+10*(_curPage-1)],
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  color: Color(0xff333333),
                                                  // fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Text(_testId[idx].toString(), style: TextStyle(fontSize: 13),),
                                            Text(
                                              '${_correctCount[idx+10*(_curPage-1)]}',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color(0xff4478FF)),
                                            ),
                                            Text(
                                              '/${_probCount[idx+10*(_curPage-1)]}',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color(0xff333333)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )));
                  },
                  itemCount: pageTotal,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.black,
                          activeColor: Color(0xff4478FF),
                          size: 20.0,
                          activeSize: 20.0)),
                  // control: SwiperControl(),
                  onIndexChanged: (index) {
                    _curPage = index + 1;
                  },
                ),
              ))
            ])))));
  }

  late List _type = [];
  late List _content = [];
  late List _correct = [];
  late List _testProbId = [];


}
