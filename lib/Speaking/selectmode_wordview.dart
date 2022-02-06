import 'package:flutter/material.dart';

class SelectModeWordPage extends StatelessWidget {
  const SelectModeWordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('말하기 연습 - 단어'),),
      body: new Container(
        margin: EdgeInsets.only(top: 130.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: new Icon(
                Icons.sort_by_alpha_outlined,
                color: Color(0xff5AA9DD),
                size: 180.0,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xff97D5FE),
                  child: new Text(
                    '단어 선택하기',
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
                    '랜덤 연습하기',
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
      ),
    );
  }
}
