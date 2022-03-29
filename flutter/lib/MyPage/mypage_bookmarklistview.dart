import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'dart:convert';

import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class BookMarkListPage extends StatefulWidget {
  const BookMarkListPage({Key? key}) : super(key: key);

  @override
  _BookMarkListPageState createState() => _BookMarkListPageState();
}

// https://blogmarch.com/create-tab-inside-body-widget/

class _BookMarkListPageState extends State<BookMarkListPage> with TickerProviderStateMixin {

  final List<String> lr_bookmarkList = <String>["lr_word", "Bm", 'C', 'D', 'E', 'F', 'G', 'practice', 'lipreading', 'bookmarklist'];
  final List<String> sp_bookmarkList = <String>["sp_word", "Bm", 'C', 'D', 'E', 'F', 'G', 'practice'];

  final int _numPages = 10;
  final int _currentPage = 0;

  Future<void> speakingBookmarkInfo() async {

    //TO DO 사용자 정보 받아오기 성공할 경우 받아온 이메일로 조회할 수 있도록 재설정
    Map<String, String> _queryParameters = <String, String>{
      'email': email,
    };


    var url = Uri.http('${serverHttp}:8080', '/bookmark/speaking', _queryParameters);


    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5wZWFybEBuYXZlci5jb20iLCJpYXQiOjE2NDU0OTY5NDEsImV4cCI6MTY0NTQ5ODc0MX0.g5kqasAyvzWZ_ZkENa6UaXf6_qyiYarmu6xn12CbW7U" });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        speakingBookmarkInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  Future<void> readingBookmarkInfo() async {

    //TO DO 사용자 정보 받아오기 성공할 경우 받아온 이메일로 조회할 수 있도록 재설정
    Map<String, String> _queryParameters = <String, String>{
      'email': email,
    };


    var url = Uri.http('${serverHttp}:8080', '/bookmark/reading', _queryParameters);


    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "X-AUTH-TOKEN": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5wZWFybEBuYXZlci5jb20iLCJpYXQiOjE2NDU0OTY5NDEsImV4cCI6MTY0NTQ5ODc0MX0.g5kqasAyvzWZ_ZkENa6UaXf6_qyiYarmu6xn12CbW7U" });

    print(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(response.body);
    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        readingBookmarkInfo();
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  @override
  void initState() {
    speakingBookmarkInfo();
    readingBookmarkInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(
                '책갈피 목록',
                style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
              ),
              backgroundColor: Color(0xffC8E8FF),
              foregroundColor: Color(0xff333333),
            ),

          body: Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 50.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              SizedBox(height: 30.0),
              DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        color: Color(0xffC8E8FF),
                      ),
                      child: TabBar(
                        indicatorColor: Color(0xffC8E8FF),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Color(0xff97D5FE),),
                        tabs: [
                          Tab(
                            child: Text(
                              '구화 학습',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '말하기 학습',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 50.0, right: 50.0),
                        height: 500, //height of TabBarView
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                              left: BorderSide(color: Colors.grey, width: 0.5),
                              right: BorderSide(color: Colors.grey, width: 0.5),
                              bottom: BorderSide(color: Colors.grey, width: 0.5),
                            )
                        ),
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: ListView.builder(
                              //padding: const EdgeInsets.symmetric(vertical: 30),
                                itemCount: lr_bookmarkList.length,
                                itemBuilder: (BuildContext context, int index){
                                return Container(
                                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                              '${lr_bookmarkList[index]}'
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            onPressed: (){
                                              print('click: ${index}');
                                              },
                                            icon: Icon(Icons.play_arrow_rounded),
                                          )
                                        )

                                      ],
                                    ),
                                  ),
                                );
                                }
                            )
                          ),
                          Container(
                              child: ListView.builder(
                                //padding: const EdgeInsets.symmetric(vertical: 30),
                                  itemCount: sp_bookmarkList.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Container(
                                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                  '${sp_bookmarkList[index]}'
                                              ),
                                            ),
                                            Container(
                                                child: IconButton(
                                                  onPressed: (){
                                                    print('click: ${index}');
                                                  },
                                                  icon: Icon(Icons.play_arrow_rounded),
                                                )
                                            )

                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              )
                          ),
                        ])
                    )


                  ])
              ),
            ]),
          ),
        );
  }
}
