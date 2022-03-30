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
      appBar: AppBar(
          title: Text(
            '말하기 연습 - 한 글자',
            style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
          ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: new Container(
            color: Color(0xfff0f8ff),
        padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 100.0),
        child: new Column(
            children: [ Expanded(child: GridView.count(
              crossAxisCount: 3,
              children: consonantList.asMap().map((index,data) => MapEntry(index, GestureDetector(

                  onTap: (){
                    getGridViewSelectedItem(context, data, index);
                  },
                  child: Container(

                      margin:EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration:BoxDecoration(
                          color: (index/3)%2 < 1 ? Color(0xffD8EFFF) : Color(0xff97D5FE),
                          borderRadius:BorderRadius.all(Radius.circular(15.0))
                      ) ,

                      child: Center(
                        child: Text(
                          data,
                          style: TextStyle(fontSize: 42, color: Color(0xff333333), fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),

                      ))))
              ).values.toList(),
            ),)
            ]),
      ));


  }
}
