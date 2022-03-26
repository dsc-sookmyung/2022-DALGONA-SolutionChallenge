import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lr_sentencepractice.dart';

class LrModeSentencePage extends StatelessWidget {
  const LrModeSentencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '말하기 연습 - 문장',
            style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
          ),
          backgroundColor: Color(0xffC8E8FF),
          foregroundColor: Color(0xff333333),
        ),
        body: new Container(
          margin: EdgeInsets.only(top: 50.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '상황 선택하기',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '인사하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:1, situation: '인사하기'))
                      );
                    }
                ),
                height: 40,
              ),


              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '날짜와 시간 말하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:2,situation: '날짜와 시간 말하기'))
                      );
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '날씨 말하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:3, situation: '날씨 말하기'))
                      );
                    }
                ),
                height: 40,
              ),


              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '부탁 요청하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:4, situation: '부탁 요청하기'))
                      );
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xffD8EFFF),
                    child: new Text(
                      '기분 표현하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> SentencePracticePage(id:5, situation: '기분 표현하기'))
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
