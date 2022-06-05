import 'dart:async';

import 'package:flutter/material.dart';
import 'Login/login.dart';
import 'tabbar_mainview.dart';
import 'LipReading/practice/lr_wordpractice.dart';
// import 'LipReading/test/lr_testresult.dart';

void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => new LoginPage()
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: Color(0xfff0f8ff),
      child: Center(
      child: Container(
              // alignment:Alignment.center,
              child: Image.asset('images/splashLogo.png'),
      ),
        //   child: Stack(
        //     children:[
        //       Container(
        //         // alignment:Alignment.center,
        //         child: Image.asset('images/zerozonelogo2.png'),
        //       ),
        //       Positioned(
        //           bottom: 70.0,
        //           child: Container(
        //             margin: EdgeInsets.only(right: 20.0, left: 30.0),
        //             child: Text('ZERO ZONE', style: TextStyle(fontSize: 45.0,color: Color(0xff5AA9DD), fontWeight: FontWeight.w600, ),),)
        //       ),
        //       Positioned(
        //         bottom:10.0,
        //           child: Container(
        //             margin: EdgeInsets.only(right: 5.0, left: 5.0),
        //             child: Text('COMMUINCATION  DIFFICULTIES  ZERO',style: TextStyle(fontSize:16.0,color: Color(0xff5AA9DD)),),
        //           )
        //       )
        // ])
      )
      )
    );
  }
}
