import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Login/refreshToken.dart';


class SpLetterPracticePage extends StatefulWidget {

  final String letter;
  final int letterId;

  final String url;
  final String type;

  final int probId;

  const SpLetterPracticePage({Key? key, required this.letter, required this.letterId, required this.url, required this.type, required this.probId}) : super(key: key);

  @override
  _SpLetterPracticePageState createState() => _SpLetterPracticePageState();
}

List<CameraDescription> cameras = <CameraDescription>[];

class _SpLetterPracticePageState extends State<SpLetterPracticePage> {


  bool _isStared = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '.';
  String _pronounceTip = '혀를 입천장에 붙였다 떼면서 발음하세요.';

  double _confidence = 1.0;
  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _cameraInitialized = false;
  //late CameraController _cameraController;
  //late Future<void>_initializeControllerFuture; //Future to wait until camera initializes
  //int selectedCamera = 0;

  void letterBookmark(int probId) async {

    Map<String, String> _queryParameters = <String, String>{
      'speakingProbId': probId.toString(),
    };

    var url = Uri.http('localhost:8080', '/bookmark/speaking', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

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
        letterBookmark(probId);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }


  @override
  void initState() {
    print("practice letter page url: ${widget.url}");
    _controller = VideoPlayerController.network(
      "${widget.url}",
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    // initializeCamera(selectedCamera);
    super.initState();
    _speech = stt.SpeechToText();
  }

  // // initializeCamera(int cameraIndex) async {
  // //   _cameraController = CameraController(
  // //       widget.cameras[cameraIndex],
  // //       ResolutionPreset.medium
  // //   );
  //
  //   _initializeControllerFuture = _cameraController.initialize();
  // }


  @override
  void dispose() {
    _controller.dispose();

    // if(_cameraController != null){
    //   _cameraController?.dispose();
    // }
    //_cameraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "한 글자 연습",
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
                              width: 160,
                              height: 160,
                            ),
                            Row(
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
                            )


                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffC8E8FF),
                          ),
                          width: 160,
                          height: 160,
                          child: Center(
                            child: Text(
                              '${widget.letter}',
                              style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        )
                      ],
                    ),

                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "다음과 같이 발음하고 있습니다.",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                    ),

                    Container(
                      margin: EdgeInsets.only(top:10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // child: CameraPreview(_cameraController),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff97D5FE),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              height: 160,
                              width: 160,
                              child: Text('camera here!'),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xff97D5FE),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                height: 160,
                                width: 160,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      '${_text}',
                                      style: const TextStyle(
                                        fontSize: 50.0,
                                        color: Color(0xff333333),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0, ),
                          padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Color(0xffD8EFFF),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          height: 100,
                          child: Center(
                            child: Text(
                              '${_pronounceTip}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                        )
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
      if (_isStared) {
        _isStared = false;
      } else {
        _isStared = true;
      }
    });
  }
}
