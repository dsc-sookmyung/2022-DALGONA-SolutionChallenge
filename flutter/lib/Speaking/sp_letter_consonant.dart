import 'package:flutter/material.dart';
import 'package:zerozone/Login/login.dart';

import 'sp_letter_vowel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ChooseConsonantPage extends StatefulWidget {
  const ChooseConsonantPage({Key? key}) : super(key: key);

  @override
  _ChooseConsonantPageState createState() => _ChooseConsonantPageState();
}

class _ChooseConsonantPageState extends State<ChooseConsonantPage> {

  List<String> consonantList = ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

  getGridViewSelectedItem(BuildContext context, String gridItem, int index){
    //
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ChooseVowelPage(consonant: gridItem, consonantIndex: index+1,))
    );
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
                                "말하기 한 글자 연습",
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
                                      children: consonantList
                                          .asMap()
                                          .map((index, data) => MapEntry(
                                          index,
                                          GestureDetector(
                                              onTap: () {
                                                getGridViewSelectedItem(
                                                    context, data, index);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
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
                                                      data,
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
