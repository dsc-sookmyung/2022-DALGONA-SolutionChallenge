import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpCustomWordPracticePage extends StatefulWidget {

  final int probId;
  final String type;
  final String word;
  final String url;

  const SpCustomWordPracticePage({Key? key, required this.probId, required this.type, required this.word, required this.url}) : super(key: key);
  @override
  _SpCustomWordPracticePageState createState() => _SpCustomWordPracticePageState();
}

class _SpCustomWordPracticePageState extends State<SpCustomWordPracticePage> {


  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '.';

  double _confidence = 1.0;
  double _videoSpeed = 1.0;

  bool _volume = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      '${widget.url}',
    );

    print("widget url: ${widget.url}");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    super.initState();
    _speech = stt.SpeechToText();

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: AvatarGlow(
            animate: _isListening,
            glowColor: Color(0xff4478FF),
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Color(0xff4478FF),),
            ),
          ),
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xffF3F4F6),
                    Color(0xffEFF4FA),
                    Color(0xffECF4FE),
                  ],
                  stops: [0.3, 0.7, 0.9,],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffECF4FE))),
                      // color: Colors.amber,
                      margin: EdgeInsets.only(top: 10.0),
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
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
                            child: widget.type == "word" ?
                            Text(
                              "단어",
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800),
                            )
                                :
                            Text(
                              "문장",
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800),
                            )
                            ,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0, bottom: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "다음 글자를 발음해 보세요!",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: FutureBuilder(
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: 270/100,
                                                child: VideoPlayer(_controller),
                                              );
                                            } else {
                                              return Center(child: CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                        height: 210,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            _volume ? setState(() {
                                                              _volume = false; _controller.setVolume(0.0);
                                                            }
                                                            ) : setState(() {
                                                              _volume = true;_controller.setVolume(2.0);
                                                            }
                                                            );},
                                                          child: Container(
                                                            width: 50.0,
                                                            height: 40.0,
                                                            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
                                                            decoration: new BoxDecoration(
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.6), spreadRadius: 0,
                                                                  blurRadius: 0.8,
                                                                  offset: Offset(2, 3), // changes position of shadow
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
                                                    ],
                                                  ),
                                                  Padding(padding: EdgeInsets.all(5.0)),
                                                  Column(
                                                    children: [
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
                                                            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
                                                            decoration: new BoxDecoration(
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.6),
                                                                  spreadRadius: 0,
                                                                  blurRadius: 0.8,
                                                                  offset: Offset(2, 3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                                              size: 28,
                                                              color: Color(0xff4478FF),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: InkWell(
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
                                                ),
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
                                                Container(
                                                  child: InkWell(
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
                                                        padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
                                                        decoration: new BoxDecoration(
                                                          borderRadius:
                                                          new BorderRadius.circular(10.0),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.6),
                                                              spreadRadius: 0,
                                                              blurRadius: 0.8,
                                                              offset: Offset(2, 3), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(Icons.add, size: 25, color: Color(0xff4478FF),),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 25.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      // color: Color(0xffEFEFFF),
                                      border: Border.all(color: Color(0xff4478FF), width: 2.0)
                                  ),
                                  height: 70,
                                  child: Center(
                                    child: Text(
                                      '${widget.word}',
                                      style: TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 30.0, bottom: 15.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "다음과 같이 발음하고 있습니다.",
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: Color(0xffC8E8FF),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xff4478FF),

                                    ),
                                    height: 70,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          '${_text}',
                                          style: const TextStyle(
                                            fontSize: 30.0,
                                            color: Color(0xffFFFFFF),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                ),
              )
          ),
        )
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

}
