
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zerozone/Custom/createCustomProblemPage.dart';
import 'package:zerozone/Custom/createCustomSpeakPage.dart';
import 'package:zerozone/Custom/lrCustomProblemListPage.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Custom/spCustomProblemListPage.dart';
import 'package:zerozone/Login/login.dart';
import 'dart:convert';

import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class customMainPageView extends StatefulWidget {
  const customMainPageView({Key? key}) : super(key: key);

  @override
  State<customMainPageView> createState() => _customMainPageViewState();
}

class _customMainPageViewState extends State<customMainPageView> {

  final lipReadingList = new List<LipReadingList>.empty(growable: true);
  final speakingList = new List<SpeakingList>.empty(growable: true);

  Future<void> getLipReadingList() async {

    var url = Uri.http('${serverHttp}:8080', '/custom/reading/all');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];
      // data = data["content"];

      print(data);

      lipReadingList.clear();

      for(dynamic i in data){
        String a = i["type"];
        String b = i["content"];
        int c = i["probId"];

        lipReadingList.add(LipReadingList(a, b, c));
      }

       print("lipReadingList: ${lipReadingList}");

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => lrCustomProblemListPage(lipReadingList: lipReadingList))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        getLipReadingList();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

  Future<void> getSpeakingList() async {

    var url = Uri.http('${serverHttp}:8080', '/custom/speaking/all');

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];
      // data = data["content"];

      // print(data);

      speakingList.clear();

      for(dynamic i in data){
        String a = i["type"];
        String b = i["content"];
        int c = i["probId"];

        speakingList.add(SpeakingList(a, b, c));
      }

      print("speakingList: ${speakingList}");

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => spCustomProblemListPage(speakingList: speakingList))
      );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        getLipReadingList();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }
  }

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

        child: SafeArea(
          child: Container(

            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:20.0),
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                Expanded(
                  child: SingleChildScrollView(

                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      // decoration: BoxDecoration(
                      //     color: Color(0xffF1EEE9),
                      //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[


                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 0.0, right: 15.0, top: 5.0, bottom: 20.0),
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                            width: 220.0,
                            decoration: BoxDecoration(
                              color: Color(0xffF3F8FF),
                              border: Border.all(
                                  color: Color(0xff4478FF),
                                  width: 2.0
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.9),
                              //     spreadRadius: 0,
                              //     blurRadius: 2,
                              //     offset: Offset(1, 2), // changes position of shadow
                              //   ),
                              // ],

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
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*36/100,
                                      height: MediaQuery.of(context).size.width*36/100,
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
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
                                            Icons.face,
                                            color: Color(0xff4478FF),
                                            size: 90.0,
                                          ),
                                          Container(
                                              child: Text(
                                                "구화 문제",
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
                                          context, MaterialPageRoute(builder: (_) => CustomSpeakProblemPage())
                                      );                          },
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width*36/100,
                                      height: MediaQuery.of(context).size.width*36/100,
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
                                            Icons.record_voice_over,
                                            color: Color(0xff4478FF),
                                            size: 90.0,
                                          ),
                                          Text(
                                            "말하기 문제",
                                            style: TextStyle(
                                                color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )
                                )

                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top:35.0)),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom:20.0),
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                            width: 220.0,
                            decoration: BoxDecoration(
                              color: Color(0xffF3F8FF),
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
                            margin: EdgeInsets.only(bottom: 50.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    getLipReadingList();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
                                      // borderRadius: new BorderRadius.circular(16.0),
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
                                                color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    getSpeakingList();
                                  },
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),

                                      // borderRadius: new BorderRadius.circular(16.0),
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
                                                color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
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
          ),
        )
      )

    );
  }
}
