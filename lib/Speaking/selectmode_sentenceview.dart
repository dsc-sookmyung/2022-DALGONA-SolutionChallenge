import 'package:flutter/material.dart';

class SelectModeSentencePage extends StatelessWidget {
  const SelectModeSentencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '말하기 연습 - 문장',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Colors.black,
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
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    //
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
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    //
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
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    //
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
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    //
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
                    '기분 표하기',
                    style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    //
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
