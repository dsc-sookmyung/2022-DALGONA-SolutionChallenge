import 'package:flutter/material.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

import '../../Mypage/mypage_lr_bookmarkview.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage(
      {Key? key,
      required this.testId,
      required this.testProbId,
      required this.type,
      required this.content,
      required this.correct,
      required this.date,
      required this.title,
      required this.score});
  final String date, title, score;
  final int testId;
  final List testProbId, type, content, correct;

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  late List _testProbId = widget.testProbId;
  late List _type = widget.type;
  late List _content = widget.content;
  late List _correct = widget.correct;

  // Future<void> _ProList(int id, int page) async {
  //   _type.clear();
  //   _content.clear();
  //   _correct.clear();
  //   _testProbId.clear();
  //
  //   Map<String, String> _queryParameters = <String, String>{
  //     'testId': id.toString(),
  //     'page': page.toString()
  //   };
  //
  //   var url = Uri.http(
  //       '${serverHttp}:8080', '/reading/test/list/probs', _queryParameters);
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
  //       setState(() {
  //         _type.add(_list[i]['type']);
  //         _testProbId.add(_list[i]['testProbId']);
  //         _content.add(_list[i]['content']);
  //         _correct.add(_list[i]['correct']);
  //       });
  //     }
  //     print('저장 완료');
  //   } else if (response.statusCode == 401) {
  //     await RefreshToken(context);
  //     if (check == true) {
  //       _ProList(id, page);
  //       check = false;
  //     }
  //   }
  // }

  Future<void> practiceLipReading(int idx) async {
    late var url;
    print(_testProbId[idx]);

    Map<String, String> _queryParameters = <String, String>{
      'testProbId': _testProbId[idx].toString(),
    };

    print(idx);
    print("type: ${_type[idx]}");

    url = Uri.http(
        '${serverHttp}:8080', '/reading/test/list/probs/result', _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];
      data=data["readingProb"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      bool bookmarked = data["bookmarked"];
      String content=data["content"];
      String space=data["spacingInfo"];
      String hint=data["hint"];

        Navigator.push(context,
            MaterialPageRoute(builder: (_) => BookmarkPracticePage(probId: probId, content: content, hint: hint, url: url, bookmarked: bookmarked, type: type, space: space,)));

    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        practiceLipReading(idx);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
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
                        "시험 결과",
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
                      padding: EdgeInsets.only(
                        right: 50,
                        left: 50,
                        top: 5.0,
                        bottom: 5.0,
                      ),
                    // padding: EdgeInsets.only(right:10, left: 10),
                      child: Column(children: [
                        // Padding(padding: EdgeInsets.only(top: 5.0)),
                                Container(
                                  height: MediaQuery.of(context).size.height*10/100,
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 20.0, right: 20.0),
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
                                              '${widget.date}',
                                              style: TextStyle(fontSize: 13, color: Color(0xff666666), fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2.0)),
                                            Text(
                                              '${widget.title}',
                                              style: TextStyle(
                                                fontSize: 28,
                                                color: Color(0xff4478FF),
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ]),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${widget.score}',
                                            style: TextStyle(fontSize: 21.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xffC8E8FF),
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
                                ),
                                ...List.generate(_content.length,
                                      (idx) => Container(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        practiceLipReading(idx);
                                        // await _ProList(idx);
                                        // Navigator.push(
                                        //     context, MaterialPageRoute(
                                        //     builder: (_) => ReviewListPage2(totalPage: _Page,totalElements: _Element,testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/10',)));
                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 6 / 100,
                                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0,),
                                        // padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border: Border(
                                              left: BorderSide(
                                                color: _type[idx] == "Word" ? Color(0xff2D31FA) : (_type[idx] == "Sentence" ? Color(0xff161D6E) : Color(0xff00BBF0)),
                                                width: 5.0,
                                              ),
                                              right: BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              top: BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.black,
                                                width: 1.0,
                                              )
                                          ),
                                          // borderRadius: BorderRadius.circular(15.0),
                                          boxShadow:[
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: Offset(2, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          // mainAxisAlignment:
                                          // MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                        Container(
                                          margin: EdgeInsets.only(left:3.0),
                                          child: Icon(
                                            _correct[idx]
                                                ? CustomIcons.check
                                                : Icons.clear,
                                            color: _correct[idx]
                                                ? Colors.green
                                                : Colors.red,
                                            size:
                                            _correct[idx] ? 18.0 : 22.0,
                                          ),
                                        ),
                                            _correct[idx]?
                                            Padding(padding: EdgeInsets.only(left:5.0)): Padding(padding: EdgeInsets.only(left:2.0)),
                                            if(_type[idx]=='Word')
                                              Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 15 / 100,
                                                      // alignment: Alignment.center,
                                                      // padding: EdgeInsets.only(right: 10.0),
                                                      child: Text('단 어',
                                                        style: TextStyle(
                                                            fontSize: 20, color: Color(0xff333333), fontWeight: FontWeight.w700
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 50 / 100,
                                                      padding: EdgeInsets.only(left: 10.0),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          )
                                                      ),
                                                      child: Text( _content[idx],
                                                        style: TextStyle(
                                                            fontSize: 18, color: Color(0xff333333)),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    )
                                                  ]
                                              )
                                            else
                                              Row(
                                                  children: [
                                                    Container(
                                                      // alignment: Alignment.center,
                                                      width: MediaQuery.of(context).size.width * 15 / 100,
                                                      // padding: EdgeInsets.only(right: 10.0),
                                                      child: Text(_type[idx]=='Letter'? '글 자' :'문 장',
                                                        style: TextStyle(
                                                            fontSize: 20, color: Color(0xff333333), fontWeight: FontWeight.w700
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 50 / 100,
                                                      padding: EdgeInsets.only(left: 10.0),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          )
                                                      ),
                                                      child: Text( _content[idx],
                                                        style: TextStyle(
                                                            fontSize: 18, color: Color(0xff333333)),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    )
                                                  ]
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      )]))
            )));
  }
}
