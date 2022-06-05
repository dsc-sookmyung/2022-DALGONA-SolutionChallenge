import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Speaking/sp_practiceview_letter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zerozone/server.dart';

class CodeList {
  final String code;
  final int index;

  CodeList(this.code, this.index);
}

class ChooseCodePage extends StatefulWidget {

  final List<CodeList> codeList;

  const ChooseCodePage({Key? key, required this.codeList}) : super(key: key);

  @override
  State<ChooseCodePage> createState() => _ChooseCodePageState();
}

class _ChooseCodePageState extends State<ChooseCodePage> {

  void urlInfo(String letter, int letterId) async {
    Map<String, String> _queryParameters = <String, String>{
      'id' : letterId.toString(),
    };
    var url = Uri.http('${serverHttp}:8080', '/speaking/practice/letter', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);
    print("response: ${response.statusCode}");

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];
      bool bookmarked = data["bookmarked"];
      int letterId = data["letterId"];


      print("url : ${url}");
      print("type : ${data}");

      _saveRecent(letterId, 'Letter', letter);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpLetterPracticePage(letter: letter, letterId: letterId, url: url, type: type, probId: probId, bookmarked: bookmarked,))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        urlInfo(letter, letterId);
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
                                "한 글자 연습: 종성",
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
                        // height: MediaQuery.of(context).size.height-100,
                          child: Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),

                            child: Column(
                                children: [
                                  Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      children: widget.codeList.asMap().map((index,data) => MapEntry(index,
                                          GestureDetector(
                                              onTap: () {
                                                urlInfo(data.code, data.index);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      color: (index / 3) % 2 < 1
                                                          ? Color(0xffD8EFFF)
                                                          : Color(0xff97D5FE),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                                  child: Center(
                                                    child: Text(
                                                      data.code,
                                                      style: TextStyle(
                                                          fontSize: 42,
                                                          color: Color(0xff333333),
                                                          fontWeight: FontWeight.w700),
                                                      textAlign:
                                                      TextAlign.center,
                                                    ),
                                                  )))))
                                          .values
                                          .toList(),
                                    ),
                                  )
                                ]),
                          ))
                    ]
                    )
                )
            )
        )
    );
  }
}


