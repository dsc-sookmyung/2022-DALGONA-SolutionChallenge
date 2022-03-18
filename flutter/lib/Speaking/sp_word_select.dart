import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sp_practiceview_word.dart';

class WordSelectPage extends StatefulWidget {
  const WordSelectPage({Key? key}) : super(key: key);

  @override
  State<WordSelectPage> createState() => _WordSelectPageState();
}

class _WordSelectPageState extends State<WordSelectPage> {

  final List<String> wordList = <String>["sp_word", "Bm", 'C', 'D', 'E', 'F', 'G', 'practice'];

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
        child: Column(
          children: [
            Container(
                child: ListView.builder(
                  //padding: const EdgeInsets.symmetric(vertical: 30),
                    itemCount: wordList.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                    '${wordList[index]}'
                                ),
                              ),
                              Container(
                                  child: IconButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (_) => SpWordPracticePage())
                                      );
                                    },
                                    icon: Icon(Icons.play_arrow_rounded),
                                  )
                              )

                            ],
                          ),
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
