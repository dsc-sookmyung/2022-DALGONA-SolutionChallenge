import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'lr_testinfo.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class lrTestModePage extends StatefulWidget {
  const lrTestModePage({Key? key}) : super(key: key);

  @override
  _lrTestModePageState createState() => _lrTestModePageState();
}

class _lrTestModePageState extends State<lrTestModePage> {
  late var totalProbCnt;

  _Cnt(String ver) async{
    var url;
    if(ver=='단어')
      url = Uri.http('${serverHttp}:8080', '/reading/test/word');
    else if(ver=='문장')
      url = Uri.http('${serverHttp}:8080', '/reading/test/sentence');
    else if(ver=='랜덤')
      url = Uri.http('${serverHttp}:8080', '/reading/test/random');
    else if(ver=='북마크')
      url = Uri.http('${serverHttp}:8080', '/reading/test/bookmark');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"});
    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      var data=body['data'];
      totalProbCnt=data['totalProbCount'];
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _Cnt(ver);
        check = false;
      }
    }
  }

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
                CustomIcons.book,
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
                        fontSize: 18.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async{
                    await _Cnt('단어');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => lrTestInfoPage(ver: '단어', cnt: totalProbCnt)));
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
                        fontSize: 18.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async{
                    await _Cnt('문장');
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => lrTestInfoPage(ver: '문장', cnt: totalProbCnt,))
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
                        fontSize: 18.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async{
                    await _Cnt('랜덤');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => lrTestInfoPage(ver: '랜덤', cnt: totalProbCnt)));
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
                    '북마크',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    await _Cnt('북마크');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => lrTestInfoPage(ver: '북마크', cnt: totalProbCnt)));
                  }),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
