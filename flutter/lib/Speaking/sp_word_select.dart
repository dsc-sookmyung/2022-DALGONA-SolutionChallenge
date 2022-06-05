import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Speaking/sp_word_consonant.dart';
import 'package:zerozone/server.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'sp_practiceview_word.dart';

class WordSelectPage extends StatefulWidget {

  final String consonant;
  final List<WordList> wordList;

  const WordSelectPage({Key? key, required this.consonant, required this.wordList}) : super(key: key);

  @override
  State<WordSelectPage> createState() => _WordSelectPageState();
}

class _WordSelectPageState extends State<WordSelectPage> {

  Future<void> urlInfo(String letter, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'id' : index.toString(),
    };

    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/word', _queryParameters);

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
      int wordId = data["wordId"];

      print("url : ${url}");
      print("type : ${type}");

      _saveRecent(wordId, 'Word', letter);

      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpWordPracticePage(url: url, type: type, probId: probId, word: letter, bookmarked: bookmarked,))
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

  void initState() {
    _loadRecent();

    super.initState();
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
            stops: [0.3, 0.7, 0.9,],
          ),
        ),
        child:SafeArea(
          child: Container(
            child: Column(
              children: [
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
                        margin: EdgeInsets.only(bottom: 15.0),
                        alignment: Alignment.center,
                        width: 300.0,
                        child: Text(
                          "단어 연습",
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
                    margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 40.0),
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
                            '선택한 자음: ${widget.consonant}',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                            // width: 300,
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     width: 2,
                            //     color: Colors.grey,
                            //   ),
                            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            // ),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: widget.wordList.length,
                                itemBuilder: (context, idx){
                                  return GestureDetector(
                                    onTap: (){
                                      urlInfo(widget.wordList[idx].word, widget.wordList[idx].index);

                                    },
                                    child: Container(
                                      height: 48,
                                      alignment: Alignment.center,
                                      child: Text(
                                        widget.wordList[idx].word,
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
                )
              ],
            ),
          ),
        )


    ));
  }
}
