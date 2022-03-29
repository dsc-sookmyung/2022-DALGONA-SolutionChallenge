import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
// import 'package:camera/camera.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';


class SpWordPracticePage extends StatefulWidget {

  final int probId;
  final String type;
  // final String wordId;
  final String word;
  final String url;
  final bool bookmarked;

  // required this.probId, required this.type, required this.wordId, required this.word, required this.url

  const SpWordPracticePage({Key? key, required this.probId, required this.type, required this.word, required this.url, required this.bookmarked}) : super(key: key);
  @override
  _SpWordPracticePageState createState() => _SpWordPracticePageState();
}

class _SpWordPracticePageState extends State<SpWordPracticePage> {

  bool _isChecked = false;
  bool _isStared = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '.';

  double _confidence = 1.0;
  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  void wordBookmark(int probId) async {

    Map<String, String> _queryParameters = <String, String>{
      'speakingProbId': probId.toString(),
    };

    var url = Uri.http('104.197.249.40:8080', '/bookmark/speaking', _queryParameters);

    var response = await http.post(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      print("북마크에 등록되었습니다.");
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        wordBookmark(probId);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  void deleteWordBookmark(int probId) async {

    Map<String, String> _queryParameters = <String, String>{
      'speakingProbId': probId.toString(),
    };

    var url = Uri.http('104.197.249.40:8080', '/bookmark/speaking', _queryParameters);

    var response = await http.delete(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      print("북마크가 해제되었습니다.");
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        deleteWordBookmark(probId);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }


  @override
  void initState() {
    _controller = VideoPlayerController.network(
      '${widget.url}',
    );

    //..initialize().then((_) {
    //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //       setState(() {});
    //     })

    print("widget url: ${widget.url}");
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
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "단어 연습",
                style: TextStyle(
                    color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              foregroundColor: Color(0xff333333),
              backgroundColor: Color(0xffC8E8FF),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  padding: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "다음 글자를 발음해 보세요!",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            onPressed: _pressedStar,
                            icon: (
                                ( (_isChecked == true && _isStared) ||(_isChecked == false && widget.bookmarked)  )
                                    ? Icon(Icons.star)
                                    : Icon(Icons.star_border)
                            ),
                            iconSize: 23,
                            color: Colors.amber,
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
                                      child: ElevatedButton(
                                        onPressed: (){
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
                                          minimumSize: Size(35, 25),
                                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Icon(
                                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          size: 20,
                                          color: Color(0xff97D5FE),
                                        ),
                                      )
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                            child: ElevatedButton(
                                              onPressed: (){
                                                setState(() {
                                                  if(_videoSpeed>0.25){
                                                    _videoSpeed -= 0.25;
                                                  }
                                                });
                                                _controller.setPlaybackSpeed(_videoSpeed);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xffC8E8FF),
                                                minimumSize: Size(35, 25),
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
                                            )
                                        ),
                                        Container(
                                          child: Text(
                                              '$_videoSpeed'
                                          ),
                                          width: 30,
                                        ),
                                        Container(
                                            child: ElevatedButton(
                                              onPressed: (){
                                                setState(() {
                                                  if(_videoSpeed < 1.5){
                                                    _videoSpeed += 0.25;
                                                  }
                                                });
                                                _controller.setPlaybackSpeed(_videoSpeed);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xffC8E8FF),
                                                minimumSize: Size(35, 25),
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
                                            )
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
                        margin: EdgeInsets.only(top: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffC8E8FF),
                          ),
                          height: 70,
                          child: Center(
                            child: Text(
                              '${widget.word}',
                              style: TextStyle(
                                fontSize: 38, fontWeight: FontWeight.w600,
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

                      // Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(5),
                      //       color: Color(0xffC8E8FF),
                      //     ),
                      //     margin: EdgeInsets.only(top: 10.0, bottom:15.0),
                      //     height: 130,
                      //     child: Center(
                      //       child: Text(
                      //         'camera',
                      //         style: TextStyle(
                      //           fontSize: 38, fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     )
                      // ),

                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xff97D5FE),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            height: 70,
                            child: Container(
                              child: Center(
                                child: Text(
                                  '${_text}',
                                  style: const TextStyle(
                                    fontSize: 38.0,
                                    color: Color(0xff333333),
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
      if (_isStared || (!_isChecked && widget.bookmarked)) {
        _isStared = false;
        _isChecked = true;
        deleteWordBookmark(widget.probId);
      } else {
        _isStared = true;
        _isChecked = true;
        wordBookmark(widget.probId);
      }
    });
  }
}
