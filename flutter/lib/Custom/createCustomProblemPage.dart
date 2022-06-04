import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'dart:convert';

import 'package:zerozone/Login/refreshToken.dart';
import 'package:zerozone/server.dart';

class createCustomProblemPage extends StatefulWidget {
  const createCustomProblemPage({Key? key}) : super(key: key);

  @override
  State<createCustomProblemPage> createState() => _createCustomProblemPageState();
}

enum Kind {
  WORD,
  SENTENCE
}

class _createCustomProblemPageState extends State<createCustomProblemPage> {

  TextEditingController inputController = TextEditingController();
  TextEditingController hintController = TextEditingController();

  String inputText = '';

  bool _isChecked = false;
  Kind _kind = Kind.WORD;

  void createReadingCustom(String type, String content, String hint) async {

    // final data = jsonEncode({'name': editName});

    var url = Uri.http('${serverHttp}:8080', '/custom/reading');

    var data = jsonEncode({
      'type' : type,
      'content': content,
      'hint': hint,
    });

    if(hint == ""){
      data = jsonEncode({
        'type' : type,
        'content': content,
      });
    }

    print("data: ${data}");



    // name = editName;

    var response = await http.post(url, body: data, headers: {
      'Accept': 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer ${authToken}"
    });

    print(url);
    print("response: ${response.statusCode}");

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];



      Navigator.of(context).pop();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (_) => SpLetterPracticePage(letter: letter, letterId: letterId, url: url, type: type, probId: probId, bookmarked: bookmarked,))
      // );

    }
    else if(response.statusCode == 401){
      await RefreshToken(context);
      if(check == true){
        createReadingCustom(type, content, hint);
        check = false;
      }
    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  void createLipReadingVideo(String text) async {

    text = jsonEncode(text);
    var url = Uri.https('${address}', '/predict/${text}');
    var response = await http.get(url);

    print(url);
    print("machine Learning response: ${response.statusCode}");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            child: SafeArea(
              child: Container(
                  margin: EdgeInsets.only(left: 10.0, top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                          height: 48.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Container(
                                width: 20.0,
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back),
                                  iconSize: 20,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                alignment: Alignment.center,
                                child: Text(
                                  "연습문제 만들기",
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                                  ),
                                ),

                              ),
                            ],
                          )
                      ),



                      Expanded(
                          // height: MediaQuery.of(context).size.height - 120.0,
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(left: 30.0, right: 40.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 15.0, bottom: 20.0),
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
                                    child: Text(
                                      "연습 문제 구분",
                                      style: TextStyle(
                                          color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffD8EFFF),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 140.0,
                                          child: RadioListTile(
                                              title: Text("단어"),
                                              value: Kind.WORD,
                                              groupValue: _kind,
                                              onChanged: (value) {
                                                setState(() {
                                                  _kind = value as Kind;
                                                }
                                                );
                                              }
                                          ),
                                        ),
                                        Container(
                                          width: 140.0,
                                          child: RadioListTile(
                                              title: Text("문장"),
                                              value: Kind.SENTENCE,
                                              groupValue: _kind,
                                              onChanged: (value) {
                                                setState(() {
                                                  _kind = value as Kind;
                                                });
                                              }
                                          )
                                        ),

                                      ],
                                    ),
                                  ),


                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 35.0, bottom: 20.0),
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
                                    child: Text(
                                      "추가할 연습 문제",
                                      style: TextStyle(
                                          color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffD8EFFF),
                                      // border: Border.all(
                                      //     color: Color(0xff4478FF),
                                      //     width: 2.0
                                      // ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "❗️주의 사항❗️",
                                            style: TextStyle(
                                                color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w800
                                            ),
                                          ),
                                        ),


                                        Text(
                                          "한글 외에 숫자, 영어는 문장 정보에 포함되지 않습니다. 문제 입력시 숫자와 영어를 한글로 적어주시기 바랍니다. \n️",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 16, fontWeight: FontWeight.w500
                                          ),
                                        ),

                                        Text(
                                          "예시️",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 17, fontWeight: FontWeight.w700
                                          ),
                                        ),

                                        Text(
                                          "지금은 2시입니다 → 지금은 두 시입니다",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 16, fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),



                                  Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    width: double.infinity,
                                    height: 50.0,
                                    child: TextField(
                                      controller: inputController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff97D5FE)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff97D5FE)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 35.0, bottom: 20.0),
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
                                    child: Text("연습 문제의 힌트",
                                      style: TextStyle(
                                          color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                  // hint of the problem
                                  Container(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffD8EFFF),
                                      // border: Border.all(
                                      //     color: Color(0xff4478FF),
                                      //     width: 2.0
                                      // ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)
                                      ),
                                    ),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "❗️주의 사항❗️",
                                            style: TextStyle(
                                                color: Color(0xff333333), fontSize: 18, fontWeight: FontWeight.w800
                                            ),
                                          ),
                                        ),

                                        Text(
                                          " 연습 문제의 힌트는 초성으로 제시해 주시기 바라며 띄어쓰기를 지켜 주시기 바랍니다.\n️ 힌트를 추가하지 않을 경우, 초성이 자동으로 생성됩니다.\n",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 16, fontWeight: FontWeight.w500
                                          ),
                                        ),

                                        Text(
                                          "예시️",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 17, fontWeight: FontWeight.w700
                                          ),
                                        ),

                                        Text(
                                          "오늘도 좋은 하루 보내세요 \n → ㅇㄴㄷ ㅈㅇ ㅎㄹ ㅂㄴㅅㅇ",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 16, fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    width: double.infinity,
                                    height: 50.0,
                                    child: TextField(
                                      controller: hintController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff97D5FE)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          borderSide: BorderSide(width: 1.5, color: Color(0xff97D5FE)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Container(
                                  //   child: Row(
                                  //     children: [
                                  //       Checkbox(
                                  //           value: _isChecked,
                                  //           onChanged: (value){
                                  //             setState(() {
                                  //               _isChecked = value!;
                                  //             });
                                  //             print(value);
                                  //           }
                                  //       ),
                                  //
                                  //       Text(
                                  //         "개발자에게 공식 연습 문제의 추가 요청하기",
                                  //         style: TextStyle(
                                  //             color: Color(0xff333333), fontSize: 14, fontWeight: FontWeight.w500
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),


                                  Container(
                                    margin: EdgeInsets.only(top:40.0, bottom: 30.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        createLipReadingVideo(inputController.text);

                                        var type = "word";

                                        if(_kind == Kind.SENTENCE){
                                          type = "sentence";
                                        }

                                        print(inputController.text);
                                        print(hintController.text);

                                        createReadingCustom(type, inputController.text, hintController.text);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xff97D5FE),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)
                                          ),
                                        ),
                                        child: Text(
                                          "연습 문제 생성하기",
                                          style: TextStyle(
                                              color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ),

                          )
                      )




                    ],
                  )
              ),
            )
        )

    );
  }
}
