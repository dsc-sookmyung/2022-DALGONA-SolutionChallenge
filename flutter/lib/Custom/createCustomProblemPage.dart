import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class createCustomProblemPage extends StatefulWidget {
  const createCustomProblemPage({Key? key}) : super(key: key);

  @override
  State<createCustomProblemPage> createState() => _createCustomProblemPageState();
}

class _createCustomProblemPageState extends State<createCustomProblemPage> {

  TextEditingController inputController = TextEditingController();
  String inputText = '';

  bool _isChecked = false;

  updateYet(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '업데이트 예정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('추후 업데이트 될 예정입니다.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Container(
                margin: EdgeInsets.only(left: 10.0, top: 50.0),
                child: new Column(
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



                    Container(
                      height: MediaQuery.of(context).size.height - 120.0,
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
                                  child: Text("추가할 연습 문제",
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
                                        "지금은 2시입니다. \n → 지금은 두 시입니다.",
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
                                        " 연습 문제의 힌트는 초성으로 제시해 주시기 바라며 띄어쓰기를 지켜 입력해 주시기 바랍니다.\n️ 힌트를 추가하지 않을 경우, 초성이 자동으로 생성됩니다.\n",
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
                                      updateYet();
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
            )
        )

    );
  }
}
