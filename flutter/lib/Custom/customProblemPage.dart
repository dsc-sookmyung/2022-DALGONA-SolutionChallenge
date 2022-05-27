import 'package:flutter/material.dart';

class customProblemPageView extends StatefulWidget {
  const customProblemPageView({Key? key}) : super(key: key);

  @override
  State<customProblemPageView> createState() => _customProblemPageViewState();
}

class _customProblemPageViewState extends State<customProblemPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "커스텀하기",
          style: TextStyle(
              color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
      ),
    );
  }
}
