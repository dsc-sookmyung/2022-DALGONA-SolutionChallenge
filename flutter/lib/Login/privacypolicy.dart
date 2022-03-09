import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '개인정보 이용 동의',
          style: TextStyle(color: Color(0xff5AA9DD), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 35.0, right: 35.0, bottom: 20.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Color(0xff5AA9DD),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                width: 300,
                height: 550,
                child: Text(
                  'a',
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
