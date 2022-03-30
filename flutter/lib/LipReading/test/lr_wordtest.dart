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
  final int num;
  final int time;
  final Map data;
  final String title;
  const WordTestPage(
      {Key? key,
      required this.title,
      required this.num,
      required this.time,
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

  final myController = TextEditingController();

  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var _correct_num = 0;
  var testResult = <Map>[];

  var _totalTime = 0;
  late var _time = widget.time;
  late Timer _timer;

  late var body = widget.data['data'];
  late var testinfo = body['readingProbResponseDtoList'];
  var pro_num = 1;

  late var _probId = testinfo[pro_num - 1]['probId'];
  late var _hint = testinfo[pro_num - 1]['hint'];
  late var _ans = testinfo[pro_num - 1]['content'];
  late var _url = testinfo[pro_num - 1]['url'];
  late bool _isStared = testinfo[pro_num - 1]['bookmarked'];

  void initState() {
    setState(() {
      _controller = VideoPlayerController.network(_url);
    });
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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

  void ReadingBookmark(int probId) async {
    Map<String, String> _queryParameters = <String, String>{
      'readingProbId': probId.toString(),
    };

    var url =
        Uri.http('${serverHttp}:8080', '/bookmark/reading', _queryParameters);

    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      print("북마크에 등록되었습니다.");
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        ReadingBookmark(probId);
        check = false;
      }
    } else {
      print('error : ${response.reasonPhrase}');
    }
  }

  void deleteReadingBookmark(int probId) async {
    Map<String, String> _queryParameters = <String, String>{
      'readingProbId': probId.toString(),
    };

    var url =
        Uri.http('${serverHttp}:8080', '/bookmark/reading', _queryParameters);

    var response = await http.delete(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      print("북마크가 해제되었습니다.");
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        deleteReadingBookmark(probId);
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child: GestureDetector(
            onTap: () {
              //FocusManager.instance.primaryFocus?.unfocus();
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    '남은 시간: $_time 초',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                  centerTitle: true,
                  backgroundColor: Color(0xffC8E8FF),
                  foregroundColor: Color(0xff333333),
                ),
                body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                        height: height - height / 8,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top:10.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10.0)),
                                Text(
                                  "무슨 말인지 맞춰보세요!",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                // Padding(padding: EdgeInsets.only(right: 180.0)),
                                // IconButton(
                                //   onPressed: _pressedStar,
                                //   icon: (_isStared
                                //       ? Icon(Icons.star)
                                //       : Icon(Icons.star_border)),
                                //   iconSize: 23,
                                //   color: Colors.amber,
                                // ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
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
                            Padding(padding: EdgeInsets.all(2.0)),
                            Row(
                              //동영상 플레이 버튼
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 1.0)),
                                Column(
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.only(
                                              top: 9.5,
                                              bottom: 9.5,
                                              right: 14.0,
                                              left: 14.0),
                                          primary: Color(0xffC8E8FF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Icon(
                                          CustomIcons.to_start,
                                          size: 17,
                                          color: Color(0xff97D5FE),
                                        ),
                                        onPressed: () {}),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(3.0)),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            _controller.play();
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xffC8E8FF),
                                        minimumSize: Size(45, 37),
                                        padding: EdgeInsets.only(
                                            right: 5.0, left: 5.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 21,
                                        color: Color(0xff97D5FE),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(right: 130.0)),
                                Container(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_videoSpeed > 0.25) {
                                        _videoSpeed -= 0.25;
                                      }
                                    });
                                    _controller.setPlaybackSpeed(_videoSpeed);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xffC8E8FF),
                                    minimumSize: Size(40, 35),
                                    padding:
                                        EdgeInsets.only(right: 5.0, left: 5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Color(0xff97D5FE),
                                  ),
                                )),
                                // Padding(padding: EdgeInsets.only(right: 8.0)),
                                Container(
                                  child: Text('$_videoSpeed', textAlign: TextAlign.center,),
                                  width: 40,
                                ),
                                Container(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_videoSpeed < 1.5) {
                                        _videoSpeed += 0.25;
                                      }
                                    });
                                    _controller.setPlaybackSpeed(_videoSpeed);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xffC8E8FF),
                                    minimumSize: Size(40, 35),
                                    padding:
                                        EdgeInsets.only(right: 5.0, left: 5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Color(0xff97D5FE),
                                  ),
                                )),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '당신의 답은...',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(padding: EdgeInsets.only(left: 120.0)),
                                InkWell(
                                  onTap: () {
                                    _clickHint = true;
                                    _pressedHint();
                                  },
                                  child: _isHint
                                      ? new Text(
                                          '힌트 닫기',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        )
                                      : new Text(
                                          "힌트 보기",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(2.0)),
                            Container(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isHint
                                      ? Bubble(
                                          color: Color(0xff97D5FE),
                                          // stick: true,
                                          nip: BubbleNip.rightTop,
                                          margin: BubbleEdges.only(
                                              top: 2.0,
                                              bottom: 3.0,
                                              right: 3.0,
                                              left: 3.0),
                                          child: Text(_hint,
                                              style: TextStyle(
                                                  color: Color(0xff333333),
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600)),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 3.0, left: 15.0, right: 15.0),
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
                            Padding(padding: EdgeInsets.all(3.0)),
                            Column(children: [
                              // 확인 버튼
                              if (!_seeAnswer) ...{
                                if (_enterAnswer) _Answer() else _reAnswer()
                              } else ...{
                                if (_isCorrect) _Correct() else _Wrong()
                              }
                            ]),
                            Spacer(),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Text(
                                    '$pro_num/${widget.num}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xff333333)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: width / 6)),
                                Container(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: Color(0xff97D5FE),
                                              width: 1.0),
                                        ),
                                        minimumSize: Size(80, 40),
                                      ),
                                      onPressed: () async {
                                        _check();
                                        if (pro_num == widget.num) {
                                          _controller.pause();
                                          await _score(body['id'], testResult,
                                              _correct_num);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      lrTestResultPage(
                                                        title: widget.title,
                                                        cnt:
                                                            '$_correct_num/${widget.num}',
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
                                      child: Text(
                                        '다음',
                                        style: TextStyle(
                                          color: Color(0xff97D5FE),
                                          fontSize: 16.0,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ))))),
        onWillPop: (){
          setState(() {
            _controller.pause();
            _timer.cancel();
          });
          //_quitDialog();
          return Future(() => true);
          // _recent.length>0?
          // _AddRecent(_recent): null;
        }
        );
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
          borderSide: BorderSide(width: 2, color: Color(0xff97D5FE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 2, color: Color(0xff97D5FE)),
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
          primary: Color(0xff97D5FE),
          minimumSize: Size(80, 40),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (myController.text == _ans) {
            //정답
            setState(() {
              _isCorrect = true;
              _seeAnswer = true;
              _isInit = false;
              _correct_num++;
              _timer.cancel();
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
                  primary: Color(0xff97D5FE),
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
                  ),
                )),
            Padding(padding: EdgeInsets.all(5.0)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffFFFFFF),
                  minimumSize: Size(90, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: Color(0xff97D5FE), width: 1.0),
                ),
                onPressed: () {
                  setState(() {
                    _seeAnswer = true;
                    _isCorrect = false;
                    _isInit = false;
                    _timer.cancel();
                  });
                },
                child: Text(
                  '답 보기',
                  style: TextStyle(
                    color: Color(0xff97D5FE),
                    fontSize: 18,
                  ),
                )),
          ],
        )
      ],
    ));
  }

  void _pressedStar() {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_isStared) {
        _isStared = false;
        deleteReadingBookmark(_probId);
      } else {
        _isStared = true;
        ReadingBookmark(_probId);
      }
    });
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
      Padding(padding: EdgeInsets.all(8.0)),
      Column(children: [
        Text(
          '정답이에요!',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
        )
      ]),
      Padding(padding: EdgeInsets.all(5.0)),
      Column(children: [
        Container(
            width: 300,
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
        Padding(padding: EdgeInsets.all(8.0)),
        Column(children: [
          Text(
            '정답은',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          )
        ]),
        Padding(padding: EdgeInsets.all(5.0)),
        Column(children: [
          Container(
              width: 300,
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
        _time--;
        _totalTime++;

        if (_time == 0) {
          _timer.cancel();

          setState(() {
            _seeAnswer = true;
            _isCorrect = false;
            _isInit = false;
          });
        }
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
                    primary: Color(0xff97D5FE),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    _next();
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  },
                  child: Text("취소", style: TextStyle(color: Colors.white)))
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
      _controller.pause();
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
      _time = widget.time;
      _controller = VideoPlayerController.network(_url);
      _initializeVideoPlayerFuture = _controller.initialize();
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
