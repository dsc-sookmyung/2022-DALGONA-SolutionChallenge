import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/custom_icons_icons.dart';
import 'lr_wordtest.dart';
import 'lr_sentencetest.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class lrTestResultPage extends StatefulWidget {
  final String title;
  final String cnt;
  final int time;
  const lrTestResultPage(
      {Key? key, required this.title, required this.cnt, required this.time})
      : super(key: key);
  @override
  _lrTestResultPageState createState() => _lrTestResultPageState();
}

class _lrTestResultPageState extends State<lrTestResultPage> {
  late final title = widget.title;
  late final totaltime = widget.time;
  late final correct = widget.cnt;

  late List score = correct.split('/');
  late double stamp = double.parse(score[0]) / double.parse(score[1]);
  bool _visibility = false;
  bool _btn_visibility = false;
  late Timer _timer;
  int _time = 0;

  late ConfettiController _controllerCenter;

  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _time++;
      if (_time == 2) {
        setState(() {
          _visibility = true;
        });
      }
      if (_time == 3) {
        setState(() {
          _btn_visibility = true;
          _timer.cancel();
        });
      }
    });
  }

  void initState() {
    _start();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     '테스트 결과',
            //     style: TextStyle(
            //         color: Color(0xff333333),
            //         fontSize: 24,
            //         fontWeight: FontWeight.w800),
            //   ),
            //   centerTitle: true,
            //   backgroundColor: Color(0xffC8E8FF),
            //   foregroundColor: Color(0xff333333),
            // ),
            body: SafeArea(
          child: Container(
              // padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
              child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                Container(
                  child: Text(
                    '$title',
                    style: TextStyle(
                        color: Color(0xffFFB800),
                        fontSize: 38.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                Container(
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image(
                            image: AssetImage('assets/images/complete.png'),
                            width: 170,
                            height: 162),
                      ),
                      Positioned(
                          top: 20,
                          left: 170,
                          child: _visibility
                              ? Image(
                                  image: AssetImage(stamp == 1
                                      ? 'assets/images/perfect.png'
                                      : stamp >= 0.5
                                          ? 'assets/images/good.png'
                                          : 'assets/images/cheer up.png'),
                                  width: 197.0,
                                  height: 187.0)
                              : Container())
                    ],
                  ),
                ),
                stamp >= 0.5
                    ? ConfettiWidget(
                        confettiController: _controllerCenter,
                        blastDirection: pi / 2 * 3,
                        particleDrag: 0.05,
                        emissionFrequency: 0.01,
                        numberOfParticles: 15,
                        gravity: 0.1,
                        shouldLoop: false,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple
                        ], // manually specify the colors to be used
                      )
                    : Container(),
                Padding(padding: EdgeInsets.all(10.0)),
                Container(
                  height: 127.0,
                  width: 249.0,
                  decoration: BoxDecoration(
                      color: Color(0xff97D5FE),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            '응시 시간',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 241.0,
                          height: 86.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xffF3F8FF),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Color(0xff97D5FE),
                                size: 30.0,
                              ),
                              Padding(padding: EdgeInsets.only(right: 5.0)),
                              Text(
                                '${totaltime} 초',
                                style: TextStyle(
                                    color: Color(0xff333333), fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Container(
                  height: 127.0,
                  width: 249.0,
                  decoration: BoxDecoration(
                      color: Color(0xff97D5FE),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          '맞은 개수',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 241.0,
                        height: 86.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xffF3F8FF),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CustomIcons.thumbs_up,
                              color: Color(0xff97D5FE),
                              size: 30.0,
                            ),
                            Padding(padding: EdgeInsets.only(right: 5.0)),
                            Text(
                              '$correct',
                              style: TextStyle(
                                  color: Color(0xff333333), fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                // _btn_visibility?
                Container(
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: _btn_visibility ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffff97D5FE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: Color(0xffff97D5FE), width: 1.0),
                              ),
                              // minimumSize: Size(100, 40),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 80.0,
                                  left: 80.0),
                              child: Text(
                                '마치기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            )))),
                // : Container(),
              ])),
        )));
  }
}
