import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class WordPracticeWrong extends StatefulWidget {
  final answer;
  const WordPracticeWrong({Key? key, required this.answer}) : super(key: key);

  @override
  _WordPracticeWrongState createState() => _WordPracticeWrongState();
}

class _WordPracticeWrongState extends State<WordPracticeWrong> {
  bool _isStared = false;
  bool _isHint = false;

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
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "단어",
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
                              fontSize: 15, fontWeight: FontWeight.w600),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isHint
                              ? Container(
                              width: 300,
                              height: 40,
                              color: Color(0xff97D5FE),
                              child: Center(
                                child: Text("ㅇㄴㅎㅅㅇ",
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600)),
                              ))
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      // height: 50.0,
                      margin:
                      EdgeInsets.only(top: 3.0, left: 15.0, right: 15.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: widget.answer,
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffEA8135), width: 2.0),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Column(children: [
                      Text('정답은', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),)
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Column(children: [
                      Container(
                          width: 300,
                          height: 50,
                          color: Color(0xff97D5FE),
                          child: Center(
                            child: Text("hello",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600)),
                          ))
                    ]),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Column(children: [
                      Text('입니다', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),)
                    ]),
                    Padding(padding: EdgeInsets.all(50.0)),
                    Container(
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
                                ),
                                minimumSize: Size(100, 40),
                              ),
                              onPressed: () {},
                              child: Text(
                                '다음',
                                style: TextStyle(
                                  color: Color(0xff97D5FE),
                                  fontSize: 18,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ))));
  }

  void _pressedStar() {
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
}
