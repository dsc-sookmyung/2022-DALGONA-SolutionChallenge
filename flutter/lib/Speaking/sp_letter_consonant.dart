import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

import 'sp_letter_vowel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsonantList {
  final String consonant;
  final int index;

  ConsonantList(this.consonant, this.index);
}

class ChooseConsonantPage extends StatefulWidget {

  final List<ConsonantList> consonantList;
  const ChooseConsonantPage({Key? key,  required this.consonantList}) : super(key: key);

  @override
  _ChooseConsonantPageState createState() => _ChooseConsonantPageState();
}

class _ChooseConsonantPageState extends State<ChooseConsonantPage> {

  // List<ConsonantList> consonantList = widget.consonantList;

  final vowelList = new List<VowelList>.empty(growable: true);

  Future<void> getVowel(String gridItem, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'onsetId' : index.toString(),
      'onset' : gridItem
    };

    var url = Uri.http('${serverHttp}:8080', '/speaking/list/letter/nucleus', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      print(data);

      if(vowelList.length == 0){
        for(dynamic i in data){
          String a = i["nucleus"];
          int b = i["id"];
          vowelList.add(VowelList(a, b));
        }
      }

      print("vowelList: ${vowelList}");

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ChooseVowelPage(consonant: gridItem, consonantIndex: index, vowelList: vowelList))
      );
      // urlInfo(letter, letterId);
      //
      // Navigator.of(context).pop();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) => ChooseConsonantPage(consonantList: consonantList))
      // );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        getVowel(gridItem, index);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  getGridViewSelectedItem(BuildContext context, String gridItem, int index){
    //
    getVowel(gridItem, index);


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
                stops: [0.3, 0.7, 0.9],
              ),
            ),
            child: SafeArea(
                child: Container(
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
                                "한 글자 연습: 초성",
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
                                      children: widget.consonantList
                                          .asMap()
                                          .map((index, data) => MapEntry(
                                          index,
                                          GestureDetector(
                                              onTap: () {
                                                getGridViewSelectedItem(
                                                    context, data.consonant, data.index);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      color: (index / 3) % 2 < 1 ? Color(0xffD8EFFF) : Color(0xff97D5FE),
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                  child: Center(
                                                    child: Text(
                                                      data.consonant,
                                                      style: TextStyle(fontSize: 42, color: Color(0xff333333), fontWeight: FontWeight.w900),
                                                      textAlign: TextAlign.center,
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
