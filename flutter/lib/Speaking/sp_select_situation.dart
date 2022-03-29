import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';
import 'sp_select_sentence.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '말하기 연습 - 문장',
            style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffC8E8FF),
          foregroundColor: Color(0xff333333),
        ),
        body: new Container(
          margin: EdgeInsets.only(top: 50.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '상황 선택하기',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '인사하기',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      getSentence(1, "인사하기");
                    }
                ),
                height: 40,
              ),


              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '날짜와 시간 말하기',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      getSentence(2, "날짜와 시간 말하기");
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '날씨 말하기',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      getSentence(3, "날씨 말하기");
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '부탁 요청하기',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      getSentence(4, "부탁 요청하기");
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '기분 표하기',
                      style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      getSentence(5, "기분 표하기");
                    }
                ),
                height: 40,
              ),

            ],
          ),
        )
    );
  }
}
