import 'package:flutter/material.dart';

class lrselectModeMainPage extends StatelessWidget {
  const lrselectModeMainPage({Key? key}) : super(key: key);

  void letterBtnSelected(){
    print('button is clicked! ');
  }


  void sentenceBtnSelected(){
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("구화 연습"),
        ),
        body: new Container(
          margin: EdgeInsets.only(top: 130.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(

                child: new Icon(
                  Icons.record_voice_over_rounded,
                  color: Color(0xff5AA9DD),
                  size: 180.0,
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:40.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '연습하기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      //
                    }
                ),
                height: 40,
              ),

              Container(
                padding: EdgeInsets.only(left: 50.0, top: 0.0, right: 50.0, bottom: 0.0),
                margin: EdgeInsets.only(left: 0.0, top:20.0, right: 0.0, bottom: 0.0),
                child: new RaisedButton(
                    color: Color(0xff97D5FE),
                    child: new Text(
                      '시험 보기',
                      style: new TextStyle(fontSize: 20.0, color: Color(0xff000000), fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      //
                    }
                ),
                height: 40,
              ),


            ],
          ),
        )
    );
  }
}

