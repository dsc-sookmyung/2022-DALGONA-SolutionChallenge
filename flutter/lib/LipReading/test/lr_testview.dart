import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lr_testinfo.dart';

class lrTestModePage extends StatelessWidget {
  const lrTestModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "시험 보기",
          style: TextStyle(
              color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: new Container(
        margin: EdgeInsets.only(top: 130.0),
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
              padding: EdgeInsets.only(
                  left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(
                  left: 0.0, top: 40.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '단어',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => lrTestInfoPage(ver: '단어 시험')));
                  }),
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(
                  left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '문장',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => lrTestInfoPage(ver: '문장 시험'))
                    );
                  }),
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(
                  left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '랜덤',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => lrTestInfoPage(ver:'랜덤 시험'))
                    );
                  }),
              height: 40,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
              margin: EdgeInsets.only(
                  left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
              child: new RaisedButton(
                  color: Color(0xffC8E8FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: new Text(
                    '즐겨찾기',
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => LrModeSentencePage())
                    // );
                  }),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
