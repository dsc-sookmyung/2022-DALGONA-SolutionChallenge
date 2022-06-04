import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';
import 'sp_practiceview_letter.dart';
import 'sp_letter_code.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class VowelList {
  final String vowel;
  final int index;

  VowelList(this.vowel, this.index);
}

class ChooseVowelPage extends StatefulWidget {

  final String consonant;
  final int consonantIndex;
  final List<VowelList> vowelList;

  const ChooseVowelPage({Key? key, required this.consonant, required this.consonantIndex, required this.vowelList }) : super(key: key);

  @override
  _ChooseVowelPageState createState() => _ChooseVowelPageState();
}

class _ChooseVowelPageState extends State<ChooseVowelPage> {

  int letterId = 0;
  String letter = 'ㄱ';

  final codeList = new List<CodeList>.empty(growable: true);


  void letterInfo(String gridItem, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'onsetId': widget.consonantIndex.toString(),
      'onset': widget.consonant,
      'nucleusId': index.toString(),
      'nucleus': gridItem
    };

    var url = Uri.http('${serverHttp}:8080', '/speaking/list/letter/coda', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);
    print("response: ${response.statusCode}");

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      if(codeList.length == 0){
        for(dynamic i in data){
          String a = i["letter"];
          int b = i["letterId"];
          codeList.add(CodeList(a, b));
        }
      }

      print("vowelList: ${codeList}");

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ChooseCodePage(codeList: codeList))
      );

      // urlInfo(letter, letterId);

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        letterInfo(gridItem, index);
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
                              margin: EdgeInsets.only(bottom: 15.0),
                              alignment: Alignment.center,
                              width: 300.0,
                              child: Text(
                                "한 글자 연습: 중성",
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
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Color(0xff4478FF),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                    width: 300,
                                    height: 50,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10.0, bottom:30.0),
                                    child: Text(
                                      '선택한 자음: ${widget.consonant}',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      children: widget.vowelList.asMap().map((index,data) => MapEntry(index,
                                          GestureDetector(
                                              onTap: () {
                                                letterInfo(data.vowel, data.index);
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
                                                      data.vowel,
                                                      style: TextStyle(
                                                          fontSize: 42,
                                                          color:
                                                          Color(0xff333333),
                                                          fontWeight:
                                                          FontWeight.w900),
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
