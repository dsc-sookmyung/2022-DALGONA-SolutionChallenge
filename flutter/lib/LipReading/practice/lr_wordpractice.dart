import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'package:zerozone/server.dart';

class WordPracticePage extends StatefulWidget {
  final int probId;
  final int id;
  final String onset;
  final String word;
  final String hint;
  final String url;
  final bool bookmarked;
  final int wordId;
  const WordPracticePage(
      {Key? key,
      required this.onset,
      required this.id,
      required this.probId,
      required this.word,
      required this.hint,
      required this.url,
      required this.bookmarked,
      required this.wordId})
      : super(key: key);

  @override
  _WordPracticePageState createState() => _WordPracticePageState();
}

class _WordPracticePageState extends State<WordPracticePage> {
  late bool _isStared = false; //widget.bookmarked;
  bool _isHint = false;
  bool _isCorrect = false; //정답 맞췄는지
  bool _enterAnswer = true; //확인  / 재도전, 답보기
  bool _isInit = true; //textfield
  bool _seeAnswer = false; //정답보기
  String color = '0xff97D5FE';
  bool _volume = false;

  final myController = TextEditingController();

  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  var data;
  late var _hint = widget.hint;
  late var _word = widget.word;
  late var _url = widget.url;
  late var _probId =widget.probId;
  late var _wordId=widget.wordId;

  void initState () {
    _controller = VideoPlayerController.network(_url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _loadRecent();

    super.initState();
  }

  List<String> _recentProbId = [];
  List<String> _recentType=[];
  List<String> _recentContent=[];

  _loadRecent() async{
    _recentProbId.clear();
    _recentType.clear();
    _recentContent.clear();

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final ret1 = prefs.getStringList('id');
      final ret2 = prefs.getStringList('type');
      final ret3 = prefs.getStringList('content');

      int len=ret1!.length;
      int len2=ret2!.length;
      int len3=ret3!.length;

      for (int i = 0; i < len; i++) {
        _recentProbId.add(ret1[i]);
        _recentType.add(ret2[i]);
        _recentContent.add(ret3[i]);
      }
    });
  }

  _saveRecent(int id, String type, String content) async {
    final prefs = await SharedPreferences.getInstance();

    _recentProbId.add(id.toString());
    _recentType.add(type);
    _recentContent.add(content);

      setState(() {
        prefs.setStringList('id', _recentProbId);
        prefs.setStringList('type', _recentType);
        prefs.setStringList('content', _recentContent);
        print('shared: '+ id.toString() +' '+ type +' '+ content);
      });
  }

  void _randomWord(String onsetId, String onset) async {
    Map<String, String> _queryParameters = <String, String>{
      'onsetId': onsetId,
      'onset': onset
    };
    Uri.encodeComponent(onsetId);
    var url = Uri.http('${serverHttp}:8080', '/reading/practice/word/random',
        _queryParameters);

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $authToken"
    });
    print(url);
    // print("Bearer $authToken");
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));
      data = body["data"];
      print(data);
      setState(() {
        _hint = data['hint'];
        _word = data['word'];
        _url = data['url'];
        _probId = data['probId'];
        _isStared = data['bookmarked'];
        _wordId=data['wordId'];
        _controller = VideoPlayerController.network(_url);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
      });
    } else if (response.statusCode == 401) {
      await RefreshToken(context);
      if (check == true) {
        _randomWord(onsetId, onset);
        check = false;
      }
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
                              "단어",
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.only(left: 25.0, right: 25.0),
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
                          IconButton(
                            onPressed: _pressedStar,
                            icon: (_isStared)
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border),
                            iconSize: 23,
                            color: Colors.amber,
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
                              return Center(child: CircularProgressIndicator());
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
                            Padding(padding: EdgeInsets.all(30.0))
                            }
                          else...{
                            _Wrong(),
                            Padding(padding: EdgeInsets.all(15.0))
                          }
                        }
                      ]),
                                      InkWell(
                                        onTap: (){
                                          if (_seeAnswer) {
                                          _next();
                                          } else
                                          _showDialog();
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
                    ])))),


                ]))))));
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
        // filled: true,
        // fillColor: Colors.white,
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
    return (

        ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff4478FF),
          padding:
              EdgeInsets.only(right: 40.0, left: 40.0, top: 13.0, bottom: 13.0),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (myController.text == _word) {
            //정답
            setState(() {
              _saveRecent(_wordId, "word", _word); //최근 학습 단어
              _isCorrect = true;
              _seeAnswer = true;
              _isInit = false;
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
                  primary: Colors.white,
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
                      color: Color(0xff4478FF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
            Padding(padding: EdgeInsets.all(5.0)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(90, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // side: BorderSide(color: Color(0xff97D5FE), width: 1.0),
                ),
                onPressed: () {
                  setState(() {
                    _saveRecent(_probId, "word", _word);
                    _seeAnswer = true;
                    _isCorrect = false;
                    _isInit = false;
                  });
                },
                child: Text(
                  '답 보기',
                  style: TextStyle(
                      color: Color(0xff4478FF),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
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
      if (_isHint) {
        _isHint = false;
      } else {
        _isHint = true;
      }
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
              child: Text(_word,
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
                child: Text(_word,
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

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Notice",
              style: TextStyle(color: Color(0xff333333)),
            ),
            content: new Text("다음 문제로 넘어가시겠어요?",
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
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff4478FF),
                    minimumSize: Size(80, 40),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("취소",
                      style: TextStyle(color: Colors.white, fontSize: 16.0)))
            ],
          );
        });
  }

  void _next() {
    setState(() {
      _randomWord((widget.id).toString(), widget.onset);
      _seeAnswer = false;
      _isInit = true;
      _enterAnswer = true;
      _isCorrect = false;
      myController.text = "";
      _isHint = false;
      _initializeVideoPlayerFuture = _controller.initialize();
      _volume?
      _controller.setVolume(1.0): _controller.setVolume(0.0);
      _controller.setPlaybackSpeed(_videoSpeed);
      _controller.pause();
      _controller.setLooping(true);

    });
  }
}
