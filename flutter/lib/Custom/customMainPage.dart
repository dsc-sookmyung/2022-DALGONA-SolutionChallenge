
import 'package:flutter/material.dart';
import 'package:zerozone/Custom/createCustomProblemPage.dart';
import 'package:zerozone/Custom/customProblemPage.dart';

class customMainPageView extends StatefulWidget {
  const customMainPageView({Key? key}) : super(key: key);

  @override
  State<customMainPageView> createState() => _customMainPageViewState();
}

class _customMainPageViewState extends State<customMainPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white,
                Color(0xffE3F2FD),
                Color(0xffBBDEFB),
              ],
              stops: [0.5, 0.8, 0.9, ],
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 50.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "커스텀하기",
                        style: TextStyle(
                            color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                        ),
                      ),

                    ),
                  ],
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  width: 220.0,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(
                        color: Color(0xff4478FF),
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)
                    ),
                  ),
                  child: Text("연습 문제 생성하기",
                    style: TextStyle(
                        color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => createCustomProblemPage())
                            );
                          },
                          child: new Container(
                            width: 140.0,
                            height: 140.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Color(0xffF3F8FF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: Offset(2, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.wordpress_outlined,
                                  color: Color(0xff4478FF),
                                  size: 90.0,
                                ),
                                Text(
                                  "단어",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                      ),

                      GestureDetector(
                          onTap: (){
                            print("Container clicked");
                          },
                          child: new Container(
                            width: 140.0,
                            height: 140.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Color(0xffF3F8FF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: Offset(2, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.draw_rounded,
                                  color: Color(0xff4478FF),
                                  size: 90.0,
                                ),
                                Text(
                                  "문장",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                      )

                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 35.0, bottom: 20.0),
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  width: 220.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff4478FF),
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)
                    ),
                  ),
                  child: Text("연습 문제 관리",
                    style: TextStyle(
                        color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 50.0,
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Color(0xffF3F8FF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(2, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "연습 문제 목록",
                            style: TextStyle(
                                color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        )
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 35.0, bottom: 20.0),
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  width: 220.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xff4478FF),
                        width: 2.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)
                    ),
                  ),
                  child: Text("커스텀 문제 연습하기",
                    style: TextStyle(
                        color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          print("clicked!");
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(16.0),
                            color: Color(0xffF3F8FF),
                            // border: Border.all(
                            //     color: Color(0xff999999),
                            //     width: 1.0
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(2, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 10.0),
                                child: Icon(
                                  Icons.face,
                                  color: Color(0xff4478FF),
                                  size: 60.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text(
                                  "구화 연습하기",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          print("clicked!");
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(16.0),
                            color: Color(0xffF3F8FF),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(2, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 10.0),
                                child: Icon(
                                  Icons.record_voice_over,
                                  color: Color(0xff4478FF),
                                  size: 60.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text(
                                  "말하기 연습하기",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      )



                    ],
                  ),
                ),



              ],
            ),
          ),
        )
      )

    );
  }
}
