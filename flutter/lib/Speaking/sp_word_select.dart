import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sp_practiceview_word.dart';

class WordSelectPage extends StatefulWidget {

  final String consonant;

  const WordSelectPage({Key? key, required this.consonant}) : super(key: key);

  @override
  State<WordSelectPage> createState() => _WordSelectPageState();
}

class _WordSelectPageState extends State<WordSelectPage> {

  final List<String> wordList = <String>["가다", "가자미", '거미', '고목', '구리', '고무', '고차원', '고리'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '말하기 연습 - 한 글자',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),

      body: new Container(
         margin: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
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
            Container(
              width: 300,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: wordList.length,
                    itemBuilder: (context, idx){
                      return GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => SpWordPracticePage())
                          );
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            wordList[idx],
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
