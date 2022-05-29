import 'package:flutter/material.dart';

class lrCustomProblemListPage extends StatefulWidget {
  const lrCustomProblemListPage({Key? key}) : super(key: key);

  @override
  State<lrCustomProblemListPage> createState() => _customProblemListPageState();
}

class _customProblemListPageState extends State<lrCustomProblemListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, top: 50.0),
          child: Column(
            children: [
              Container(
                child: Row(
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
                    Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      child: Text(
                        "구화 연습문제 목록",
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
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 50.0),
                child: SingleChildScrollView(

                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
