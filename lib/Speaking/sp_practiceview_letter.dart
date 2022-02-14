import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left:30.0, right: 30.0, top: 30.0, ),
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xff97D5FE),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      width: 300,
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
                  )
                ],
              ),
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
