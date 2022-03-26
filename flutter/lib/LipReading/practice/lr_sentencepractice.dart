import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';

class SentencePracticePage extends StatefulWidget {
  const SentencePracticePage({Key? key, required situation}) : super(key: key);

  @override
  _SentencePracticePageState createState() => _SentencePracticePageState();
}

class _SentencePracticePageState extends State<SentencePracticePage> {
  bool _isStared = false;
  bool _isHint = false;
  bool _isCorrect = true; //정답 맞췄는지
  bool _enterAnswer=true; //확인  / 재도전, 답보기
  bool _isInit = true;  //textfield
  bool _seeAnswer = false;  //정답보기
  String color = '0xff97D5FE';

  final myController = TextEditingController();

  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();

    //usingCamera();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "문장",
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              backgroundColor: Color(0xffC8E8FF),
              foregroundColor: Color(0xff333333),
            ),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                height: height-height/8,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 8.0)),
                        Text(
                          "무슨 말인지 맞춰보세요!",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Padding(padding: EdgeInsets.only(right: 180.0)),
                        IconButton(
                          onPressed: _pressedStar,
                          icon: (_isStared
                              ? Icon(Icons.star)
                              : Icon(Icons.star_border)),
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
                                  padding:
                                  EdgeInsets.only(right: 5.0, left: 5.0),
                                  primary: Color(0xffC8E8FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_left_sharp,
                                  size: 37,
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
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
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
                        Padding(padding: EdgeInsets.only(right: 8.0)),
                        Container(
                          child: Text('$_videoSpeed'),
                          width: 30,
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
                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
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
                              fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff333333)),
                        ),
                        Padding(padding: EdgeInsets.only(left: 120.0)),
                        InkWell(
                          onTap: () {
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
                            child: Text('nice to meet you',
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
                      child: Text('_ _ _ _  _ _  _ _ _ _  _ _ _', style: TextStyle(fontSize: 30, color: Color(0xff333333))),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Container(
                      margin:
                      EdgeInsets.only(top: 3.0, left: 15.0, right: 15.0),
                      child: Column(  //textfield
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
                    Column(children: [  // 확인 버튼
                      if (!_seeAnswer) ...{
                        if (_enterAnswer) _Answer() else _reAnswer()
                      } else ...{
                        if (_isCorrect) _Correct()
                        else _Wrong()
                      }
                    ]),
                    Spacer(),
                    Container(    //다음 버튼
                      alignment: AlignmentDirectional.centerEnd,
                      padding: EdgeInsets.only(right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Color(0xff97D5FE), width: 1.0),
                                ),
                                minimumSize: Size(80, 40),
                              ),
                              onPressed: () {},
                              child: Text(
                                '다음',
                                style: TextStyle(
                                  color: Color(0xff97D5FE),
                                  fontSize: 16,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                )))));
  }

  Widget _initTextField() {
    //기본 텍스트필드
    return (TextField(
      enabled: true,
      controller: myController,
      style: TextStyle(
        fontSize: 20.0,
      ),
      keyboardType: TextInputType.multiline, //입력시 가로가 길 때 줄바꿈되서 보여줌
      maxLines: null, //제한 없음
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
          if (myController.text == 'nice to meet you') { //정답
            setState(() {
              _isCorrect = true;
              _seeAnswer = true;
              _isInit=false;
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
              _isInit=false;
              _isCorrect = false;
              _enterAnswer=false;
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
                    _enterAnswer=true;
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
      } else {
        _isStared = true;
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
              child: Text("nice to meet you",
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 20.0,
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
                child: Text("nice to meet you",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 20.0,
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
}
