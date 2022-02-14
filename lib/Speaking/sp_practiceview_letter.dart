import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpLetterPracticePage extends StatefulWidget {
  //const SpLetterPracticePage({Key? key}) : super(key: key);
  @override
  _SpLetterPracticePageState createState() => _SpLetterPracticePageState();
}

class _SpLetterPracticePageState extends State<SpLetterPracticePage> {

  bool _isStared = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '버튼을 누른 후 이야기해 주세요.';
  String _practiceText ='';
  double _confidence = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "한 글자",
                style: TextStyle(
                    color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              foregroundColor: Colors.black,
              backgroundColor: Color(0xffC8E8FF),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AvatarGlow(
              animate: _isListening,
              glowColor: Color(0xffC8E8FF),
              endRadius: 75.0,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0, bottom: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "다음 글자를 발음해 보세요!",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio: 100/100,
                                      child: VideoPlayer(_controller),
                                    );
                                  } else {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              width: 150,
                              height: 150,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffC8E8FF),
                                      minimumSize: Size.zero,
                                      padding:
                                      EdgeInsets.only(right: 5.0, left: 5.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 25,
                                      color: Color(0xff97D5FE),
                                    ),
                                    onPressed: () {
                                      //
                                    }
                                ),

                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffC8E8FF),
                                      minimumSize: Size.zero,
                                      padding:
                                      EdgeInsets.only(right: 20.0, left: 20.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text("-",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Color(0xff97D5FE),
                                        )),
                                    onPressed: () {

                                    }
                                    ),

                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffC8E8FF),
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.only(
                                          right: 15.0,
                                          left: 15.0,
                                          top: 8.0,
                                          bottom: 8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_outlined,
                                      size: 20,
                                      color: Color(0xff97D5FE),
                                    ),
                                    onPressed: () {}
                                ),


                              ],
                            )


                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffC8E8FF),
                          ),
                          width: 150,
                          height: 150,
                          child: Text('$_practiceText'),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0, bottom: 10.0),
                          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                          decoration: BoxDecoration(
                              color: Color(0xff97D5FE),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          height: 100,
                          child: Container(
                            child: Text(
                              '${_text}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            )
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

  void _pressedStar() {
    setState(() {
      if (_isStared) {
        _isStared = false;
      } else {
        _isStared = true;
      }
    });
  }
}
