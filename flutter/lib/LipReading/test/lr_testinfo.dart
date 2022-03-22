import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lr_wordtest.dart';
import 'lr_sentencetest.dart';

class lrTestInfoPage extends StatefulWidget {
  final String ver;
  const lrTestInfoPage({Key? key, required this.ver}) : super(key: key);
  @override
  _lrTestInfoPageState createState() => _lrTestInfoPageState();
}

class _lrTestInfoPageState extends State<lrTestInfoPage> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GestureDetector(
        onTap: () {
      //FocusManager.instance.primaryFocus?.unfocus();
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.ver}',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 24,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),
      body:SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 160.0, bottom: 160.0, right: 30.0, left: 30.0),
          color: Color(0xffC8E8FF),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                '테스트 이름',
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  maxLength: 15,
                  controller: myController1,
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 2, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(padding: EdgeInsets.all(15.0)),
                  Container(
                    child: Text(
                      '문제 개수',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      controller: myController2,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '최대 50',
                        hintStyle: TextStyle(fontSize: 15.0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    '개',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(padding: EdgeInsets.all(15.0)),
                  Text(
                    '응시 시간',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      controller: myController3,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '최대 60',
                        hintStyle: TextStyle(fontSize: 15.0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 2, color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text(
                    '초',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(15.0)),
                ],
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffff97D5FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xffff97D5FE), width: 1.0),
                    ),
                    // minimumSize: Size(100, 40),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if(widget.ver=='단어 시험'){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => WordTestPage(num: int.parse(myController2.text), time: int.parse(myController3.text))));
                    }
                    else if(widget.ver=='문장 시험'){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SentenceTestPage(num: int.parse(myController2.text), time: int.parse(myController3.text))));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 20.0, left: 20.0),
                    child: Text(
                      '테스트 시작',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              Padding(padding: EdgeInsets.all(10.0)),
            ],
          ),
        ),
      ),
      ),
    )
    );
  }
}