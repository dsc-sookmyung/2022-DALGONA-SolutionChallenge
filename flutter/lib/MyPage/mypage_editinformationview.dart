import 'package:flutter/material.dart';

class ModifyInformationPage extends StatefulWidget {
  const ModifyInformationPage({Key? key}) : super(key: key);

  @override
  _ModifyInformationPageState createState() => _ModifyInformationPageState();
}

class _ModifyInformationPageState extends State<ModifyInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 정보 수정',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Colors.black,
      ),

      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 40.0, right: 40.0, bottom: 130.0),
        padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 30.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Color(0xff5AA9DD),
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only( bottom: 50.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 2.0,
                      color: Colors.black
                  )
              ),
              height: 150,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '이름: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              height: 35,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '이메일: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              height: 35,
            ),

            Container(
              child: RaisedButton(
                child: Text(
                    '저 장',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Color(0xffC8E8FF),
              ),
              width: 300,
            )

          ],
        ),

      ),

    );
  }
}

