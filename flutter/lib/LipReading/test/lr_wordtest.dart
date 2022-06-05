import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'lr_testresult.dart';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/server.dart';

class WordTestPage extends StatefulWidget {
  final Map data;
  final String title;
  const WordTestPage(
      {Key? key,
      required this.title,
      required this.data})
      : super(key: key);

  @override
  _WordTestPageState createState() => _WordTestPageState();
}

class _WordTestPageState extends State<WordTestPage> {
  bool _isHint = false;
  bool _clickHint = false;
  bool _isCorrect = true; //정답 맞췄는지
  bool _enterAnswer = true; //확인  // 재도전, 답보기
  bool _isInit = true; //textfield
  bool _seeAnswer = false; //정답보기
  String color = '0xff97D5FE';
  bool _volume=false;

  final myController = TextEditingController();

  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var _correct_num = 0;
  var testResult = <Map>[];

  var _totalTime = 0;
  late Timer _timer;

  late var body = widget.data['data'];
  late var testinfo = body['readingProbResponseDtoList'];
  var pro_num = 1;

  late var _probId = testinfo[pro_num - 1]['probId'];
  late var _hint = testinfo[pro_num - 1]['hint'];
  late var _ans = testinfo[pro_num - 1]['content'];
  late var _url = testinfo[pro_num - 1]['url'];

  void initState() {
    setState(() {
      _controller = VideoPlayerController.network(_url);
    });
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _start();
    super.initState();
  }

  _score(int testId, var list, int correctCnt) async {
    var url = Uri.http('${serverHttp}:8080', '/reading/test/result');

    final data = jsonEncode(
        {'testId': testId, 'testResultList': list, 'correctCount': correctCnt});

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
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _score(testId, list, correctCnt);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  void dispose() {
    _timer.cancel();
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        body: GestureDetector(
            onTap: () {
              //FocusManager.instance.primaryFocus?.unfocus();
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
                      child: Column(
                          children: [
                      Container(
                      decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffECF4FE))),
              // color: Colors.amber,
              margin: EdgeInsets.only(top: 10.0),
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.pause();
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: 10.0),
                    alignment: Alignment.center,
                    width: 300.0,
                    child: Text(
                      "${pro_num}/10",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "무슨 말인지 맞춰보세요!",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Container(
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio: 100 / 100,
                                      child: VideoPlayer(_controller),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              width: 380,
                              height: 200,
                            ),
                            Padding(padding: EdgeInsets.all(4.0)),
                            Row(
                              //동영상 플레이 버튼
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            _volume
                                                ? setState(() {
                                              _volume = false;
                                              _controller.setVolume(0.0);
                                            })
                                                : setState(() {
                                              _volume = true;
                                              _controller.setVolume(2.0);
                                            });
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 40.0,
                                            padding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            decoration: new BoxDecoration(
                                              // border: Border.all(
                                              //     width:1,
                                              //     color: Color(0xff4478FF)
                                              // ),
                                              borderRadius:
                                              new BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  spreadRadius: 0,
                                                  blurRadius: 0.8,
                                                  offset: Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _volume
                                                  ? Icons.volume_up
                                                  : Icons.volume_off,
                                              size: 25,
                                              color: Color(0xff4478FF),
                                            ),
                                          )),
                                      Padding(padding: EdgeInsets.all(5.0)),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                              } else {
                                                _controller.play();
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 40.0,
                                            padding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            decoration: new BoxDecoration(
                                              // border: Border.all(
                                              //     width:1,
                                              //     color: Color(0xff4478FF)
                                              // ),
                                              borderRadius:
                                              new BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  spreadRadius: 0,
                                                  blurRadius: 0.8,
                                                  offset: Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              size: 28,
                                              color: Color(0xff4478FF),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_videoSpeed > 0.25) {
                                                _videoSpeed -= 0.25;
                                              }
                                            });
                                            _controller.setPlaybackSpeed(_videoSpeed);
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 40.0,
                                            padding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            decoration: new BoxDecoration(
                                              // border: Border.all(
                                              //     width:1,
                                              //     color: Color(0xff4478FF)
                                              // ),
                                              borderRadius:
                                              new BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  spreadRadius: 0,
                                                  blurRadius: 0.8,
                                                  offset: Offset(
                                                      2, 3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 25,
                                              color: Color(0xff4478FF),
                                            ),
                                          )),
                                      // Padding(padding: EdgeInsets.only(left: 8.0)),
                                      Container(
                                        child: Text(
                                          '${_videoSpeed}x',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                                        ),
                                        width: 60,
                                      ),
                                      // Padding(padding: EdgeInsets.only(right: 8.0)),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_videoSpeed < 1.5) {
                                                _videoSpeed += 0.25;
                                              }
                                            });
                                            _controller.setPlaybackSpeed(_videoSpeed);
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 40.0,
                                            padding: EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            decoration: new BoxDecoration(
                                              // border: Border.all(
                                              //     width:1,
                                              //     color: Color(0xff4478FF)
                                              // ),
                                              borderRadius:
                                              new BorderRadius.circular(10.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  spreadRadius: 0,
                                                  blurRadius: 0.8,
                                                  offset: Offset(
                                                      2, 3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 25,
                                              color: Color(0xff4478FF),
                                            ),
                                          )),
                                    ],
                                  ),
                                ]),
                            Padding(padding: EdgeInsets.all(5.0)),
                            InkWell(
                                onTap: () {
                                  _pressedHint();
                                },
                                child: _isHint
                                    ? Container(
                                    margin: EdgeInsets.only(top:4.0, bottom: 7.0),
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 15.0, left: 15.0),
                                    height: 50,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width * 90 / 100,
                                    decoration: BoxDecoration(
                                      color: Color(0xff97D5FE),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    // width: MediaQuery.of(context).size.width,
                                    child: Text(_hint,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w700)))
                                    : Container(
                                  // padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 15.0, left: 15.0),
                                  // height: 40,
                                    width: MediaQuery.of(context).size.width * 90 / 100,
                                    decoration: BoxDecoration(
                                      // color: Color(0xff4478FF),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),

                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      margin: EdgeInsets.only(top:4.0, bottom: 7.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff97D5FE),
                                            width: 2.0
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Text("힌트 보기",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xff97D5FE),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700)
                                      ),
                                    )
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 17.0)),
                                Text(
                                  '당신의 답은...',
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(3.0)),
                            Container(
                              width: MediaQuery.of(context).size.width * 90 / 100,
                              child: Column(
                                //textfield
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isInit
                                      ? _initTextField()
                                      : _isCorrect
                                      ? _correctTextField()
                                      : _errorTextField()
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(6.0)),
                            Column(children: [
                              // 확인 버튼
                              if (!_seeAnswer) ...{
                                if (_enterAnswer)...{
                                  _Answer(),
                                  Padding(padding: EdgeInsets.all(55.0))
                                }
                                else...{
                                  _reAnswer(),
                                  Padding(padding: EdgeInsets.all(39.0))
                                }
                              } else ...{
                                if (_isCorrect)...{
                                  _Correct(),
                                  Padding(padding: EdgeInsets.all(25.0))
                                }
                                else...{
                                  _Wrong(),
                                  Padding(padding: EdgeInsets.all(15.0))
                                }
                              }
                            ]),
                            InkWell(
                                onTap: () async{
                                  _check();
                                  if (pro_num == 10) {
                                    _controller.pause();
                                    await _score(body['id'], testResult, _correct_num);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                lrTestResultPage(
                                                  title: widget.title,
                                                  cnt:
                                                  '$_correct_num/10',
                                                  time: _totalTime,
                                                )));
                                  } else {
                                    if (_seeAnswer)
                                      _next();
                                    else {
                                      _showDialog();
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 13.0,
                                      bottom: 13.0),
                                  // height: 40,
                                  width: MediaQuery.of(context).size.width *
                                      90 /
                                      100,
                                  decoration: BoxDecoration(
                                      color: Color(0xff4478FF),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child: Text("다음",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600)),
                                )),
                              ]),
                        )))])),
        ))));
  }

  Widget _initTextField() {
    //기본 텍스트필드
    return (TextField(
      enabled: true,
      controller: myController,
      style: TextStyle(
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xff4478FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xff4478FF)),
        ),
      ),
    ));
  }

  Widget _errorTextField() {
    //답이 틀렸을 경우
    return (TextField(
        enabled: false,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          // labelText: myController.text,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffEA8135), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
        )));
  }

  Widget _correctTextField() {
    return (TextField(
        enabled: false,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          // labelText: myController.text,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff60D642), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
        )));
  }

  Widget _Answer() {
    //답 입력하기 전
    return (ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4478FF),
          padding:
          EdgeInsets.only(right: 40.0, left: 40.0, top: 13.0, bottom: 13.0),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (myController.text == _ans) {
            //정답
            setState(() {
              _timer.cancel();
              _isCorrect = true;
              _seeAnswer = true;
              _isInit = false;
              _correct_num++;
            });
          } else if (myController.text == '') {
            Fluttertoast.showToast(
              msg: '답을 적어주세요',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
            );
          } else {
            //오답
            setState(() {
              _isInit = false;
              _isCorrect = false;
              _enterAnswer = false;
            });
          }
        },
        child: Text(
          '확인',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        )));
  }

  Widget _reAnswer() {
    //답이 틀렸을 경우
    return (Column(
      children: [
        Text('다시 한 번 생각해보세요!',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        Padding(padding: EdgeInsets.all(5.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff4478FF),
                  minimumSize: Size(90, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    // _isCorrect = true;
                    _seeAnswer = false;
                    _isInit = true;
                    _enterAnswer = true;
                  });
                },
                child: Text(
                  '재도전',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                      fontWeight: FontWeight.w600
                  ),
                )),
            Padding(padding: EdgeInsets.all(5.0)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff4478FF),
                  minimumSize: Size(90, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _timer.cancel();
                    _seeAnswer = true;
                    _isCorrect = false;
                    _isInit = false;
                  });
                },
                child: Text(
                  '답 보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,fontWeight: FontWeight.w600
                  ),
                )),
          ],
        )
      ],
    ));
  }

  void _pressedHint() {
    setState(() {
      if (_isHint)
        _isHint = false;
      else
        _isHint = true;
    });
  }

  Widget _Correct() {
    return (Column(children: [
      Column(children: [
        Text(
          '정답이에요!',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
        )
      ]),
      Padding(padding: EdgeInsets.all(5.0)),
      Column(children: [
        Container(
            width: MediaQuery.of(context).size.width * 90 / 100,
            height: 50,
            color: Color(0xff97D5FE),
            child: Center(
              child: Text(_ans,
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600)),
            ))
      ]),
    ]));
  }

  Widget _Wrong() {
    return (Column(
      children: [
        Column(children: [
          Text(
            '정답은',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          )
        ]),
        Padding(padding: EdgeInsets.all(5.0)),
        Column(children: [
          Container(
              width: MediaQuery.of(context).size.width * 90 / 100,
              height: 50,
              color: Color(0xff97D5FE),
              child: Center(
                child: Text(_ans,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600)),
              ))
        ]),
        Padding(padding: EdgeInsets.all(5.0)),
        Column(children: [
          Text(
            '입니다',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          )
        ]),
      ],
    ));
  }

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime++;
      });
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Notice",
              style: TextStyle(color: Color(0xff333333)),
            ),
            content: new Text("문제를 통과하시겠어요?",
                style: TextStyle(color: Color(0xff333333))),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff4478FF),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    _next();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white,fontSize: 16.0),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff4478FF),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소", style: TextStyle(color: Colors.white,fontSize: 16.0)))
            ],
          );
        });
  }

  void _quitDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Notice",
              style: TextStyle(color: Color(0xff333333)),
            ),
            content: new Text("시험을 나가시겠어요? \n지금까지 푼 문제가 모두 오답 처리됩니다",
                style: TextStyle(color: Color(0xff333333))),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff97D5FE),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff97D5FE),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    _start();
                    Navigator.pop(context);
                  },
                  child: Text("취소", style: TextStyle(color: Colors.white)))
            ],
          );
        });
  }

  void _next() {
    setState(() {
      _timer.cancel();
      _seeAnswer = false;
      _isInit = true;
      _enterAnswer = true;
      _isCorrect = false;
      myController.text = "";
      _isHint = false;
      _clickHint = false;
      pro_num += 1;
      _ans = testinfo[pro_num - 1]['content'];
      _url = testinfo[pro_num - 1]['url'];
      _hint = testinfo[pro_num - 1]['hint'];
      _controller = VideoPlayerController.network(_url);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.pause();
      _volume?
        _controller.setVolume(1.0): _controller.setVolume(0.0);
      _controller.setPlaybackSpeed(_videoSpeed);
      _controller.setLooping(true);
      _start();
    });
  }

  void _check() {
    bool hint, correct;
    _clickHint ? hint = true : hint = false;
    _isCorrect ? correct = true : correct = false;
    testResult.add({'usedHint': hint, 'correct': correct});
  }
}
