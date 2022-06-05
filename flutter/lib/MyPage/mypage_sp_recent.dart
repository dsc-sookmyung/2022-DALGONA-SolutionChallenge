import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Speaking/sp_practiceview_letter.dart';
import 'package:zerozone/Speaking/sp_practiceview_sentence.dart';
import 'package:zerozone/Speaking/sp_practiceview_word.dart';
import 'package:zerozone/server.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SPRecentStudyPage extends StatefulWidget {
  final List<int> probId;
  final List<String> content;
  final List<String> type;

  const SPRecentStudyPage({Key? key,
    required this.probId,
    required this.type,
    required this.content
  }) : super(key: key);

  @override
  State<SPRecentStudyPage> createState() => _SPRecentStudyPageState();
}

class _SPRecentStudyPageState extends State<SPRecentStudyPage> {
  @override
  late List _probId = widget.probId;
  late List _type = widget.type;
  late List _content = widget.content;

  int _curPage=1;
  late int totalPage = _content.length%10 == 0 ? _content.length~/10: _content.length~/10+1;

  Future<void> practiceSpeaking(int idx) async {
    late var url;

    Map<String, String> _queryParameters = <String, String>{
      'id': _probId[idx].toString(),
    };
    print(idx);
    print("type: ${_type[idx]}");

    if (_type[idx] == 'Word') {
      url = Uri.http(
          '${serverHttp}:8080', '/speaking/practice/word', _queryParameters);
    } else if (_type[idx] == 'Sentence') {
      url = Uri.http(
          '${serverHttp}:8080', '/speaking/practice/sentence', _queryParameters);
    }
    else{
      url = Uri.http(
          '${serverHttp}:8080', '/speaking/practice/letter', _queryParameters);
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

      if (_type[idx] == 'Word') {
        String word = data["word"];
        type = "word";
        String space = "";

        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SpWordPracticePage(probId: probId, type: type,word: word,url: url, bookmarked: bookmarked,)));
      } else if (_type[idx] == 'Sentence') {
        String word = data["sentence"];
        String type = "sentence";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SpSentencePracticePage(probId: probId, type: type, sentence: word,url: url, bookmarked: bookmarked)
            ));
      }
      else{
        String word = data["letter"];
        String type = "letter";
        int letterId = data["letterId"];

        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SpLetterPracticePage(probId: probId, type: type, letter: word,url: url, bookmarked: bookmarked, letterId: letterId,)
            ));
      }
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        practiceSpeaking(idx);
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
                                "말하기 최근 학습",
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
                                return (
                                    Container(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Column(
                                          children: [
                                            ...List.generate(
                                              _curPage==totalPage ? _content.length-(_curPage-1)*10 : 10,
                                                  (idx) => Container(
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    practiceSpeaking(idx+10*(_curPage-1));
                                                    print(_probId[idx+10*(_curPage-1)]);
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height*6.7/100,
                                                    margin: EdgeInsets.only(right: 50, left: 50, top: 5.0, bottom: 5.0),
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Flexible(
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
                                                                        child: Text('단 어 ',
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
                                                                              fontSize: 18 , color: Color(0xff333333)),
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                        ),
                                                                      )
                                                                    ]
                                                                )
                                                            ],
                                                          ),

                                                        ),
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
                                      activeSize: 20.0
                                  )
                              ),
                              // control: SwiperControl(),
                              onIndexChanged: (index) {
                                _curPage = index+1;
                              },
                            ),
                          ))
                    ])))));
  }
}