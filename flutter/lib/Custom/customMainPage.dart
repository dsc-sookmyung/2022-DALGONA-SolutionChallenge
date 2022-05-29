
import 'package:flutter/material.dart';
import 'package:zerozone/Custom/createCustomProblemPage.dart';
import 'package:zerozone/Custom/lrCustomProblemListPage.dart';
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
      body: Container(
        // color: Color(0xffF3F4F6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xffF3F4F6),
                Color(0xffEFF4FA),
                Color(0xffECF4FE),
              ],
              stops: [0.3, 0.7, 0.9, ],
            ),
          ),
        // color: Color(0xffF1EEE9),

        child: Container(

          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.0),
                height: 50.0,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                // ),
                child: Row(
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
              ),
              Container(
                height: MediaQuery.of(context).size.height - 180.0,
                child: SingleChildScrollView(

                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    // decoration: BoxDecoration(
                    //     color: Color(0xffF1EEE9),
                    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                    // ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[


                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 10.0, bottom: 20.0),
                          padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                          width: 220.0,
                          decoration: BoxDecoration(
                            color: Color(0xffF3F8FF),
                            border: Border.all(
                                color: Color(0xff4478FF),
                                width: 2.0
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset(1, 2), // changes position of shadow
                              ),
                            ],

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
                                    height: 145.0,
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.circular(16.0),
                                      color: Colors.white,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.wordpress_outlined,
                                          color: Color(0xff4478FF),
                                          size: 90.0,
                                        ),
                                        Container(
                                            child: Text(
                                              "단어",
                                              style: TextStyle(
                                                  color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                            )
                                        )

                                      ],
                                    ),
                                  )
                              ),

                              GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (_) => createCustomProblemPage())
                                    );                          },
                                  child: new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.circular(16.0),
                                      color: Colors.white,
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
                            color: Color(0xffF3F8FF),
                            border: Border.all(
                                color: Color(0xff4478FF),
                                width: 2.0
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset: Offset(1, 2), // changes position of shadow
                              ),
                            ],
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
                          margin: EdgeInsets.only(bottom: 50.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (_) => lrCustomProblemListPage())
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    color: Colors.white,
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
                                    color: Colors.white,
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
                ),
              )
            ],
          ),
        )
      )

    );
  }
}
