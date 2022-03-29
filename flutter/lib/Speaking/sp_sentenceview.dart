import 'package:flutter/material.dart';
import 'sp_select_situation.dart';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';

import 'sp_practiceview_sentence.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectModeSentencePage extends StatefulWidget {
  const SelectModeSentencePage({Key? key}) : super(key: key);

  @override
  _SelectModeSentencePageState createState() => _SelectModeSentencePageState();
}

class _SelectModeSentencePageState extends State<SelectModeSentencePage> {

  Future<void> randomUrlInfo() async {


    var url = Uri.http('104.197.249.40:8080', '/speaking/practice/sentence/random');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      String sentence = data["sentence"];
      bool bookmarked = data["bookmarked"];

      print("url : ${url}");
      print("type : ${type}");


      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpSentencePracticePage(url: url, type: type, probId: probId, sentence: sentence, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        randomUrlInfo();
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
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),

      body: new Container(
        margin: EdgeInsets.only(top: 130.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: new Icon(
                Icons.sort_by_alpha_outlined,
                color: Color(0xff5AA9DD),
                size: 180.0,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '상황 선택하기',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SelectSituationPage())
                    );
                  }
              ),
              height: 40,
            ),


            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '랜덤 연습하기',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    randomUrlInfo();
                  }
              ),
              height: 40,
            ),

          ],
        ),
      ),
    );
  }
}
