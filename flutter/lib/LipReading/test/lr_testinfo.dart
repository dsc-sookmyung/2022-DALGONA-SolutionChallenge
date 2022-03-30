import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerozone/Login/login.dart';
import 'lr_wordtest.dart';
import 'lr_sentencetest.dart';
import 'lr_randomtest.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class lrTestInfoPage extends StatefulWidget {
  final String ver;
  final int cnt;
  const lrTestInfoPage({Key? key, required this.ver, required this.cnt}) : super(key: key);
  @override
  _lrTestInfoPageState createState() => _lrTestInfoPageState();
}

class _lrTestInfoPageState extends State<lrTestInfoPage> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  var res;
  late var totalProbCnt=widget.cnt;

  void initState(){
    super.initState();
  }

  _wordTest(String title, String count) async {
    var url = Uri.http('${serverHttp}:8080', '/reading/test/word');

    final data = jsonEncode({'testName': title, 'probsCount': count});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body=jsonDecode(utf8.decode(response.bodyBytes));
      res=body;
      Navigator.of(context).pop();
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _wordTest(title, count);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  late List _space=[];
  _sentenceTest(String title, String count) async {
    _space.clear();
    var url = Uri.http('${serverHttp}:8080', '/reading/test/sentence');

    final data = jsonEncode({'testName': title, 'probsCount': count});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body=jsonDecode(utf8.decode(response.bodyBytes));
      res=body;
      var result=res['data'];
      result=result['readingProbResponseDtoList'];
      for(int i=0;i<result.length;i++){
        var _repeat=result[i]['spacingInfo'].split("");
        var str="";
        for(int j=0;j<_repeat.length;j++){
          str += "_ " * int.parse(_repeat[j]);
          str += " ";
        }
        _space.add(str);
      }
      print(_space);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _sentenceTest(title, count);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  _randomTest(String title, String count) async {
    _space.clear();
    var url = Uri.http('${serverHttp}:8080', '/reading/test/random');

    final data = jsonEncode({'testName': title, 'probsCount': count});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body=jsonDecode(utf8.decode(response.bodyBytes));
      res=body;
      var result=res['data'];
      result=result['readingProbResponseDtoList'];
      for(int i=0;i<result.length;i++){
        var _repeat=result[i]['spacingInfo'].split("");
        var str="";
        for(int j=0;j<_repeat.length;j++){
          str += "_ " * int.parse(_repeat[j]);
          str += " ";
        }
        _space.add(str);
      }
      print(_space);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _sentenceTest(title, count);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  _bookmarkTest(String title, String count) async {
    _space.clear();
    var url = Uri.http('${serverHttp}:8080', '/reading/test/bookmark');

    final data = jsonEncode({'testName': title, 'probsCount': count});

    var response = await http.post(url, body: data, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer $authToken"} );

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body=jsonDecode(utf8.decode(response.bodyBytes));
      res=body;
      var result=res['data'];
      result=result['readingProbResponseDtoList'];
      for(int i=0;i<result.length;i++){
        var _repeat=result[i]['spacingInfo'].split("");
        var str="";
        for(int j=0;j<_repeat.length;j++){
          str += "_ " * int.parse(_repeat[j]);
          str += " ";
        }
        _space.add(str);
      }
      print(_space);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        _sentenceTest(title, count);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
        onTap: () {
      //FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.ver}',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 24,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body:SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: new Container(
        color: Color(0xfff0f8ff),
        child:Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 170.0, bottom: 230.0, right: 30.0, left: 30.0),
          color: Color(0xffC8E8FF),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                '테스트 이름',
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  maxLength: 15,
                  controller: myController1,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(padding: EdgeInsets.all(15.0)),
                  Container(
                    child: Text(
                      '문제 개수',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      controller: myController2,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '최대 $totalProbCnt',
                        hintStyle: TextStyle(fontSize: 15.0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    '개',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(padding: EdgeInsets.all(15.0)),
                  Text(
                    '응시 시간',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      controller: myController3,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '최대 60',
                        hintStyle: TextStyle(fontSize: 15.0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    '초',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffff97D5FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xffff97D5FE), width: 1.0),
                    ),
                    // minimumSize: Size(100, 40),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if(myController1.text==''){
                      Fluttertoast.showToast(
                        msg: '테스트 이름을 적어주세요',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                      );
                    }
                    else if(int.parse(myController2.text)>totalProbCnt) {
                      Fluttertoast.showToast(
                        msg: '문제의 개수가 너무 많습니다',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                      );
                    }
                    else if(int.parse(myController3.text)>60){
                      Fluttertoast.showToast(
                        msg: '응시 시간이 너무 깁니다',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.grey,
                      );
                    }
                    else {
                      if (widget.ver == '단어') {
                        await _wordTest(myController1.text, myController2.text);
                        Navigator.of(context).pop();
                        // print(res);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    WordTestPage(
                                        title: myController1.text,
                                        num: int.parse(myController2.text),
                                        time: int.parse(myController3.text),
                                        data: res)));
                      }
                      else if (widget.ver == '문장') {
                        await _sentenceTest(myController1.text, myController2.text);
                        // print(res);
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    SentenceTestPage(
                                        title: myController1.text,
                                        num: int.parse(myController2.text),
                                        time: int.parse(myController3.text),
                                        data: res,
                                        space: _space)));
                      }
                      else if (widget.ver == '랜덤' || widget.ver=='북마크') {
                        await _randomTest(myController1.text, myController2.text);
                        // print(res);
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    RandomTestPage(
                                        title: myController1.text,
                                        num: int.parse(myController2.text),
                                        time: int.parse(myController3.text),
                                        data: res,
                                        space: _space)));
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 20.0, left: 20.0),
                    child: Text(
                      '테스트 시작',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              Padding(padding: EdgeInsets.all(10.0)),
            ],
          ),
        ),
      ),
      ),
    ));
  }
}
