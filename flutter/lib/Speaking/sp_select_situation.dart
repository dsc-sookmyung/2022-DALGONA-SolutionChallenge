import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';
import 'sp_select_sentence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SentenceList {
  final String word;
  final int index;

  SentenceList(this.word, this.index);
}

class SelectSituationPage extends StatefulWidget {
  const SelectSituationPage({Key? key}) : super(key: key);

  @override
  _SelectSituationPageState createState() => _SelectSituationPageState();
}

class _SelectSituationPageState extends State<SelectSituationPage> {
  // const SelectSituationPage({Key? key}) : super(key: key);

  final sentenceList = new List<SentenceList>.empty(growable: true);

  Future<void> getSentence(int situationId, String situation) async {
    Map<String, String> _queryParameters = <String, String>{
      'situationId' : situationId.toString(),
      'situation' : situation
    };

    var url = Uri.http('${serverHttp}:8080', '/speaking/list/situation/sentence', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      for(dynamic i in data){
        String a = i["sentence"];
        int b = i["id"];
        sentenceList.add(SentenceList(a, b));
      }

      print("sentenceList: ${sentenceList}");
      // urlInfo(letter, letterId);

      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SentenceSelectPage(sentenceList: sentenceList, situation: situation,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        getSentence(situationId, situation);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 50.0,
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
                            "말하기 문장 연습",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 24,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height - 160.0,
                      child: SingleChildScrollView(
                          child: Container(
                            padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                            // decoration: BoxDecoration(
                            //     color: Color(0xffF1EEE9),
                            //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                                  padding: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                                  width: 220.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF3F8FF),
                                    border: Border.all(
                                        color: Color(0xff4478FF), width: 2.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset:
                                        Offset(1, 2), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: Text(
                                    "상황 선택하기",
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      getSentence(1, "인사하기");
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width - 50.0,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(16.0),
                                        color: Color(0xffC8E8FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(
                                                2, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "인사하기",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )),
                                Padding(padding: EdgeInsets.all(8.0)),
                                GestureDetector(
                                    onTap: () async {
                                      getSentence(2, "날짜와 시간 말하기");
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width - 50.0,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(16.0),
                                        color: Color(0xffC8E8FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(
                                                2, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "날짜와 시간 말하기",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )),
                                Padding(padding: EdgeInsets.all(8.0)),
                                GestureDetector(
                                    onTap: () async {
                                      getSentence(3, "날씨 말하기");
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width - 50.0,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(16.0),
                                        color: Color(0xffC8E8FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(
                                                2, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "날씨 말하기",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )),
                                Padding(padding: EdgeInsets.all(8.0)),
                                GestureDetector(
                                    onTap: () async {
                                      getSentence(4, "부탁 요청하기");
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width - 50.0,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(16.0),
                                        color: Color(0xffC8E8FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(
                                                2, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "부탁 요청하기",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )),
                                Padding(padding: EdgeInsets.all(8.0)),
                                GestureDetector(
                                    onTap: () async {
                                      getSentence(5, "기분 표하기");
                                    },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width - 50.0,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(16.0),
                                        color: Color(0xffC8E8FF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.9),
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(
                                                2, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "기분 표현하기",
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          )))
                ]
                )
            )
        )
    );
  }
}
