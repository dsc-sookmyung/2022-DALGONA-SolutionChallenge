import 'package:flutter/material.dart';

class createCustomProblemPage extends StatefulWidget {
  const createCustomProblemPage({Key? key}) : super(key: key);

  @override
  State<createCustomProblemPage> createState() => _createCustomProblemPageState();
}

class _createCustomProblemPageState extends State<createCustomProblemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Container(
                  margin: EdgeInsets.only(left: 10.0, top: 50.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back),
                              iconSize: 20,
                            ),
                          ),
                          Center(
                            child: Text(
                              "연습문제 만들기",
                              style: TextStyle(
                                  color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800
                              ),
                            ),

                          ),
                        ],
                      )
                    ],
                  )
              )
          ),
        )

    );
  }
}
