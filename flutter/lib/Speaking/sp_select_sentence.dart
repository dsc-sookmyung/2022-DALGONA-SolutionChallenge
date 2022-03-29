import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Speaking/sp_select_situation.dart';
import 'package:zerozone/Speaking/sp_word_consonant.dart';
import 'package:zerozone/server.dart';
import 'dart:convert';

import 'sp_practiceview_sentence.dart';

class SentenceSelectPage extends StatefulWidget {

  final List<SentenceList> sentenceList;
  final String situation;

  const SentenceSelectPage({Key? key, required this.sentenceList, required this.situation}) : super(key: key);

  @override
  State<SentenceSelectPage> createState() => _SentenceSelectPageState();
}


class _SentenceSelectPageState extends State<SentenceSelectPage> {

  Future<void> urlInfo(String letter, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'id' : index.toString(),
    };

    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/sentence', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      bool bookmarked = data["bookmarked"];

      print("url : ${url}");
      print("type : ${type}");


      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpSentencePracticePage(url: url, type: type, probId: probId, sentence: letter, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        urlInfo(letter, index);
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
        margin: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Color(0xff5AA9DD),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '${widget.situation}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
                width: 300,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.sentenceList.length,
                    itemBuilder: (context, idx){
                      return GestureDetector(
                        onTap: (){
                          urlInfo(widget.sentenceList[idx].word, widget.sentenceList[idx].index);

                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            widget.sentenceList[idx].word,
                            style: TextStyle(fontSize: 15),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              )),

                        ),

                      );
                    }
                )
            ),
          ],
        ),
      ),


    );
  }
}
