
import 'package:flutter/material.dart';

class customMainPageView extends StatefulWidget {
  const customMainPageView({Key? key}) : super(key: key);

  @override
  State<customMainPageView> createState() => _customMainPageViewState();
}

class _customMainPageViewState extends State<customMainPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "커스텀하기",
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
                Icons.draw_rounded,
                color: Color(0xff5AA9DD),
                size: 180.0,
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(left: 0.0, top:80.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '연습 문제 만들기',
                    style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    // Navigator.push(
                    //
                    // );
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
                    '연습 문제 목록',
                    style: new TextStyle(fontSize: 18.0, color: Color(0xff333333), fontWeight: FontWeight.w500),
                  ),
                  onPressed: (){
                    // Navigator.push(
                    //
                    // );
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
