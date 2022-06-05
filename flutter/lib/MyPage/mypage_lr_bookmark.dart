import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';
import 'package:card_swiper/card_swiper.dart';

import 'mypage_lr_bookmarkview.dart';

class LRBookmarkPage extends StatefulWidget {
  const LRBookmarkPage({
    Key? key,
    required this.totalPage,
    required this.totalElements,
    required this.type,
    required this.content,
    required this.testProbId,
  });
  final int totalPage, totalElements;
  final List type, content, testProbId;

  @override
  _LRBookmarkPageState createState() => _LRBookmarkPageState();
}

class _LRBookmarkPageState extends State<LRBookmarkPage> {
  late List _testProbId = widget.testProbId;
  late List _type = widget.type;
  late List _content = widget.content;

  int _curPage=1;
  late int totalPage = widget.totalElements%10 == 0 ? widget.totalElements~/10: widget.totalElements~/10+1;

  Future<void> _ProList(int page) async {
    _type.clear();
    _content.clear();
    _testProbId.clear();

    Map<String, String> _queryParameters = <String, String>{
      'page': page.toString()
    };

    var url =
    Uri.http('${serverHttp}:8080', '/bookmark/reading', _queryParameters);

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
    super.initState();
  }

  Future<void> practiceLipReading(int idx) async {
    late var url;

    Map<String, String> _queryParameters = <String, String>{
      'id': _testProbId[idx].toString(),
    };
    print(idx);
    print("type: ${_type[idx]}");

    if (_type[idx] == 'Word') {
      url = Uri.http(
          '${serverHttp}:8080', '/reading/practice/word', _queryParameters);
    } else if (_type[idx] == 'Sentence') {
      url = Uri.http(
          '${serverHttp}:8080', '/reading/practice/sentence', _queryParameters);
    }

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

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      bool bookmarked = data["bookmarked"];
      String content;
      String space=data["spacingInfo"];
      String hint=data["hint"];

      if (_type[idx] == 'Word') {
        content=data["word"];
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => BookmarkPracticePage(probId: probId, content: content, hint: hint, url: url, bookmarked: bookmarked, type: type, space: space,)));
      } else if (_type[idx] == 'Sentence') {
        content=data["sentence"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BookmarkPracticePage(probId: probId, content: content, hint: hint, url: url, bookmarked: bookmarked, type: type, space: space,)));

      }

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
                                "구화 북마크",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(padding: EdgeInsets.only(top:50.0, left: 20.0, right: 20.0)),
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
                                          _curPage == totalPage
                                              ? widget.totalElements - (_curPage - 1) * 10
                                              : 10,
                                              (idx) => Container(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                practiceLipReading(idx+10*(_curPage-1));
                                                // await _ProList(idx);
                                                // Navigator.push(
                                                //     context, MaterialPageRoute(
                                                //     builder: (_) => ReviewListPage2(totalPage: _Page,totalElements: _Element,testProbId: _testProbId,type: _type,content: _content,correct: _correct, date: _dateList[idx],title: _testName[idx],score: '${_correctCount[idx]}/10',)));
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 6.7 / 100,
                                                margin: EdgeInsets.only(right: 50, left: 50, top: 5.0, bottom: 5.0,),
                                                // padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffFFFFFF),
                                                  border: Border(
                                                      left: BorderSide(
                                                        color: _type[idx+10*(_curPage-1)] == "Word" ? Color(0xff2D31FA) : (_type[idx+10*(_curPage-1)] == "Sentence" ? Color(0xff161D6E) : Color(0xff00BBF0)),
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
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    if(_type[idx+10*(_curPage-1)]=='Word')
                                                      Row(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * 20 / 100,
                                                              alignment: Alignment.center,
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                                              child: Text( _content[idx+10*(_curPage-1)],
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
                                                              alignment: Alignment.center,
                                                              width: MediaQuery.of(context).size.width * 20 / 100,
                                                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                              child: Text(_type[idx+10*(_curPage-1)]=='Letter'? '글 자' :'문 장',
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
                                                              child: Text( _content[idx+10*(_curPage-1)],
                                                                style: TextStyle(
                                                                    fontSize: 18, color: Color(0xff333333)),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            )
                                                          ]
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ),
                                              ),
                                        )
                                      ],
                                    )));
                              },
                              itemCount: totalPage,
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
}