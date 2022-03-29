import 'package:flutter/material.dart';

import 'sp_letterview.dart';
import 'sp_wordview.dart';
import 'sp_sentenceview.dart';

class selectModeMainPage extends StatelessWidget {
  const selectModeMainPage({Key? key}) : super(key: key);

  void letterBtnSelected(){
    print('button is clicked! ');
  }


  void sentenceBtnSelected(){
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "말하기 연습",
            style: TextStyle(
                color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffC8E8FF),
        ),
      body: new Container(
        decoration: BoxDecoration(
          color: Color(0xfff0f8ff),
        ),
        padding: EdgeInsets.only(top: 130.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(

              child: new Icon(
                Icons.record_voice_over_rounded,
                color: Color(0xff5AA9DD),
                size: 180.0,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                  '한 글자 연습하기',
                  style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                ),
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SelectModeLetterPage())
                  );
                }
              ),
              height: 40,
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '단어 연습하기',
                    style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SelectModeWordPage())
                    );
                  }
              ),
              height: 40,
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '문장 연습하기',
                    style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SelectModeSentencePage())
                    );
                  }
              ),
              height: 40,
            ),


          ],
        ),
        )
    );
  }
}

