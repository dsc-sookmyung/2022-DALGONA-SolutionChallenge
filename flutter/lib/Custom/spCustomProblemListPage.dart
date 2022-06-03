import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:zerozone/Custom/practice/practiceSpeakingWordCustom.dart';

import 'package:zerozone/Login/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Speaking/sp_practiceview_sentence.dart';
import 'package:zerozone/Speaking/sp_practiceview_word.dart';
import 'package:zerozone/server.dart';

class SpeakingList {
  final String type;
  final String content;
  final int probId;

  SpeakingList(this.type, this.content, this.probId);
}

class spCustomProblemListPage extends StatefulWidget {

  final List<SpeakingList> speakingList;

  const spCustomProblemListPage({Key? key, required this.speakingList}) : super(key: key);

  @override
  State<spCustomProblemListPage> createState() => _customProblemListPageState();
}

class _customProblemListPageState extends State<spCustomProblemListPage> {

  int _curPage=1;
  late int totalPage = widget.speakingList.length%10 == 0 ? widget.speakingList.length~/10: widget.speakingList.length~/10+1;


  Future<void> practiceSpeaking(int idx) async {

    late var url;

    Map<String, String> _queryParameters = <String, String>{
      'id': widget.speakingList[idx].probId.toString(),
    };

    url = Uri.http('${serverHttp}:8080', '/custom/speaking', _queryParameters);

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
      String content = data["content"];

      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpCustomWordPracticePage(url: url, type: type, probId: probId, word: content))
      );

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
                stops: [0.3, 0.7, 0.9,],
              ),
            ),
            child: SafeArea(
                child: Container(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        height: 40.0,
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
                                "커스텀 문제: 말하기",
                                style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
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
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Column(
                                          children: [
                                            ...List.generate(
                                              _curPage==totalPage ? widget.speakingList.length-(_curPage-1)*10 : 10,
                                                  (idx) => Container(
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    print(widget.speakingList[idx].probId);
                                                    practiceSpeaking(idx);
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height*7.5/100,
                                                    margin: EdgeInsets.only(right: 40, left: 40),
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 11, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1, color: Colors.blueGrey),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            widget.speakingList[idx].type == 'word'
                                                                ? '단어' + ' - ' + widget.speakingList[idx+10*(_curPage-1)].content
                                                                : '문장' + ' - ' + widget.speakingList[idx+10*(_curPage-1)].content,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Color(0xff333333)),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
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
                              control: SwiperControl(),
                              onIndexChanged: (index) {
                                _curPage = index+1;
                              },
                            ),
                          ))
                    ]
                    )
                )
            )
        )
    );
  }
}
