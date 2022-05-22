import 'package:flutter/material.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset : false,
      body:SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: Center(
                child: Text(
                  '회원가입',
                  style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xff5AA9DD) ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                '이메일',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                      ),
                        hintText: '이메일을 입력하세요.'
                    ),
                    // cursorHeight: 25,
                    // style: TextStyle(
                    //   height: 1.0
                    // ),
                  ),
                  height: 40,
                  width: 240,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: RaisedButton(
                    color: Color(0xff97D5FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                        '인 증',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                    ),
                    onPressed: (){

                    },
                  ),
                  width: 70,
                )
              ],
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                '이메일 인증 번호',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15.0, right: 20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                      ),
                        hintText: '인증번호를 입력하세요.'
                    ),
                  ),
                  height: 40,
                  width: 240,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: RaisedButton(
                    color: Color(0xff97D5FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '확 인',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xffFFFFFF)),
                    ),
                    onPressed: (){

                    },
                  ),
                  width: 70,
                )
              ],
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '이름',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                  ),
                    hintText: '이름을 입력하세요.'
                ),
              ),
              height: 40,
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '비밀번호',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                  ),
                    hintText: '비밀번호를 입력하세요.'
                ),
              ),
              height: 40,
            ),

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                '비밀번호 확인',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              child: TextFormField(
                //validator 수정해야 함.
                validator: (value) =>
                value!.isEmpty ? '비밀번호를 다시 확인해 주세요' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff97D5FE), width: 2.0),
                  ),
                    hintText: '비밀번호를 입력하세요.'
                ),
              ),
              height: 40,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                  },
                ),
                TextButton(
                    onPressed: (){},
                    child: Text(
                        '개인정보 이용정책',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                ),
                Text('에 동의합니다.'),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new RaisedButton(
                color: Color(0xff97D5FE),
                child: new Text(
                  '회원가입',
                  style: new TextStyle(fontSize: 20.0, color: Color(0xffFFFFFF), ),
                ),
                onPressed: (){
                  //비밀번호 확인도 여기서 확인해 주어야 함.
                },
              ),
              height: 40,
            ),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이미 계정이 있으신가요?'),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                    },
                    child: Text('로그인'),
                  )
                ],
              ),
            )


          ],
        ),
      ),
      )
    );
  }
}
