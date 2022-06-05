import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  void initState() {
    _loadRecent();

    super.initState();
  }

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
      int sentenceId = data["sentenceId"];

      print("url : ${url}");
      print("type : ${type}");


      _saveRecent(sentenceId, 'Sentence', letter);


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

  List<String> _recentProbId = [];
  List<String> _recentType=[];
  List<String> _recentContent=[];

  _loadRecent() async{
    _recentProbId.clear();
    _recentType.clear();
    _recentContent.clear();

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final ret1 = prefs.getStringList('s_id');
      final ret2 = prefs.getStringList('s_type');
      final ret3 = prefs.getStringList('s_content');

      int len=ret1!.length;
      int len2=ret2!.length;
      int len3=ret3!.length;

      for (int i = 0; i < len; i++) {
        _recentProbId.add(ret1[i]);
        _recentType.add(ret2[i]);
        _recentContent.add(ret3[i]);
      }
    });
  }

  _saveRecent(int id, String type, String content) async {
    final prefs = await SharedPreferences.getInstance();

    _recentProbId.add(id.toString());
    _recentType.add(type);
    _recentContent.add(content);

    setState(() {
      prefs.setStringList('s_id', _recentProbId);
      prefs.setStringList('s_type', _recentType);
      prefs.setStringList('s_content', _recentContent);
      print('shared: '+ id.toString() +' '+ type +' '+ content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xffF3F4F6),
              Color(0xffEFF4FA),
              Color(0xffECF4FE),
            ],
            stops: [0.3, 0.7, 0.9, ],
          ),
        ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        width: 20.0,
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back),
                          iconSize: 20,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        alignment: Alignment.center,
                        child: Text(
                          "말하기 연습: 문장 선택",
                          style: TextStyle(
                              color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                          ),
                        ),

                      ),
                    ],
                  )
              ),
            ),
            Expanded(
              child: Container(
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
                            color: Color(0xff4478FF),
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
                                        color: Colors.blueGrey,
                                      )),

                                ),

                              );
                            }
                        )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )

      )
    );
  }
}
