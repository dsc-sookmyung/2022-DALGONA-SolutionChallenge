import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lr_sentencepractice.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';

class LrModeSentencePage extends StatefulWidget {
  const LrModeSentencePage({Key? key}) : super(key: key);

  @override
  _LrModeSentencePageState createState() => _LrModeSentencePageState();
}

class _LrModeSentencePageState extends State<LrModeSentencePage> {
  var data;
  String _space="";
  late var _sentence;
  late var _hint;
  late var _url;

  void _randomsentence(String situationId, String situation) async {
    Map<String, String> _queryParameters = <String, String>{
      'situationId': situationId,
      'situation': situation
    };
    // Uri.encodeComponent(situationId);
    var url = Uri.http('10.0.2.2:8080', '/reading/practice/sentence/random', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    // print("Bearer $authToken");
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      data=body["data"];
      // print(data);

      var repeat=data['spacing_info'].split("");
      for(int i=0;i<repeat.length;i++){
        _space += "_ " * int.parse(repeat[i]);
        _space += " ";
      }
      setState(() {
        _space;
        _sentence=data['sentence'];
        _hint=data['hint'];
        _url=data['url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '말하기 연습 - 문장',
            style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
          ),
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      _randomsentence('1', '인사하기');
                      print('확인: '+_sentence+' '+_space+' '+_hint+' '+_url);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:1, situation: '인사하기', sentence: _sentence,space: _space,hint: _hint,url: _url,))
                      );
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
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      _randomsentence('2', '날짜와 시간 말하기');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:2,situation: '날짜와 시간 말하기', sentence: _sentence,space: _space,hint: _hint,url: _url,))
                      );
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
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      _randomsentence('3', '날씨 말하기');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:3, situation: '날씨 말하기', sentence: _sentence,space: _space,hint: _hint,url: _url,))
                      );
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
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      _randomsentence('4', '부탁 요청하기');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:4, situation: '부탁 요청하기', sentence: _sentence,space: _space,hint: _hint,url: _url,))
                      );
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
                      '기분 표현하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      _randomsentence('5', '기분 표현하기');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:5, situation: '기분 표현하기', sentence: _sentence,space: _space,hint: _hint,url: _url,))
                      );
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
