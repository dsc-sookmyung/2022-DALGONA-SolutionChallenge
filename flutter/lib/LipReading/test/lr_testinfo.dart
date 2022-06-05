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
  const lrTestInfoPage({Key? key, required this.ver})
      : super(key: key);
  @override
  _lrTestInfoPageState createState() => _lrTestInfoPageState();
}

class _lrTestInfoPageState extends State<lrTestInfoPage> {
  final myController1 = TextEditingController();

  var res;

  void initState() {
    super.initState();
  }

  _wordTest(String title) async {
    print("wordTest");
    var url = Uri.http('${serverHttp}:8080', '/reading/test/word');

    final data = jsonEncode({'testName': title, 'probsCount': 10});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      res = body;
      var result = res['data'];
      result = result['readingProbResponseDtoList'];

      print(result);

    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _wordTest(title);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  _sentenceTest(String title) async {
    var url = Uri.http('${serverHttp}:8080', '/reading/test/sentence');

    final data = jsonEncode({'testName': title, 'probsCount': 10});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      res = body;
      var result = res['data'];
      result = result['readingProbResponseDtoList'];

      print(result);

    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _sentenceTest(title);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  _randomTest(String title) async {
    var url = Uri.http('${serverHttp}:8080', '/reading/test/random');

    final data = jsonEncode({'testName': title, 'probsCount': 10});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      res = body;
      var result = res['data'];
      result = result['readingProbResponseDtoList'];

      print(result);

    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _randomTest(title);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  _bookmarkTest(String title, String count) async {
    var url = Uri.http('${serverHttp}:8080', '/reading/test/bookmark');

    final data = jsonEncode({'testName': title, 'probsCount': count});

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });

    // print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      res = body;
      var result = res['data'];
      result = result['readingProbResponseDtoList'];

      print(result);
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _sentenceTest(title);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        body:GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xffF3F4F6),
                  Color(0xffEFF4FA),
                  Color(0xffECF4FE),
                ],
                stops: [
                  0.3,
                  0.7,
                  0.9,
                ],
              ),
            ),
            child: SafeArea(
                child: Container(
                    child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 50.0,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        iconSize: 20,
                      ),
                    ),
                    Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "구화 ${widget.ver} 시험",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height*40/100,
                      width: MediaQuery.of(context).size.width*90/100,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*20/100, bottom: MediaQuery.of(context).size.height*20/100, right: 30.0, left: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width:4, color: Color(0xff4478FF))
                        ),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(20.0)),
                          Text(
                            '테스트 이름',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Container(
                            width: MediaQuery.of(context).size.width*70/100,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 7),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 2, color: Color(0xff333333)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(width: 2, color: Color(0xff4478FF)),
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
                                  '문제 수',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              // Padding(padding: EdgeInsets.all(15.0)),
                              Container(
                                child: Text(
                                  '총 10개',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(15.0)),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff4478FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // minimumSize: Size(100, 40),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (myController1.text == '') {
                                  Fluttertoast.showToast(
                                    msg: '테스트 이름을 적어주세요',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.grey,
                                  );
                                }else if (widget.ver == '단어') {
                                    print('단어');
                                    await _wordTest(
                                        myController1.text);
                                    Navigator.of(context).pop();
                                    // print(res);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => WordTestPage(
                                                title: myController1.text,
                                                data: res)));
                                  } else if (widget.ver == '문장') {
                                    await _sentenceTest(
                                        myController1.text);
                                    // print(res);
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SentenceTestPage(
                                                title: myController1.text,
                                                data: res)));
                                  } else if (widget.ver == '랜덤' ||
                                      widget.ver == '북마크') {
                                    await _randomTest(
                                        myController1.text);
                                    // print(res);
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => RandomTestPage(
                                                title: myController1.text,
                                                data: res)));
                                  }
                                },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10.0,
                                    right: 20.0,
                                    left: 20.0),
                                child: Text(
                                  '테스트 시작',
                                  style: TextStyle(
                                      color: Colors.white,
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
            ]))))));
  }
}
