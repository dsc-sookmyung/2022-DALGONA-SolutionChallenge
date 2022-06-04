import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerozone/server.dart';
import 'package:card_swiper/card_swiper.dart';

import '../Login/login.dart';

class lrRecentStudyPage extends StatefulWidget {
  final List<int> probId;
  final List<String> content;
  final List<String> type;
  const lrRecentStudyPage(
      {Key? key,
      required this.probId,
      required this.type,
      required this.content})
      : super(key: key);

  @override
  State<lrRecentStudyPage> createState() => _lrRecentStudyPageState();
}

class _lrRecentStudyPageState extends State<lrRecentStudyPage> {
  @override
  late List _probId = widget.probId;
  late List _type = widget.type;
  late List _content = widget.content;

  int _curPage=1;
  late int totalPage = _content.length%10 == 0 ? _content.length~/10: _content.length~/10+1;

  @override
  void initState() {
    print(_probId[0].toString() + ' ' + _type[0] + ' ' + _content[0]);
    super.initState();
  }

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
                stops: [
                  0.3,
                  0.7,
                  0.9,
                ],
              ),
            ),
            child: SafeArea(
                child: Container(
                    child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 50.0,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        iconSize: 20,
                      ),
                    ),
                    Container(
                      width: 300.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "구화 최근 학습",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Swiper(
                  loop: false,
                  itemBuilder: (BuildContext context, int idx) {
                    return (
                        Container(
                            padding: EdgeInsets.only(top: 5.0),
                        child: Column(
                      children: [
                        ...List.generate(
                          _curPage==totalPage ? _content.length-(_curPage-1)*10 : 10,
                          (idx) => Container(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                print(_probId[idx+10*(_curPage-1)]);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height*6.7/100,
                                margin: EdgeInsets.only(right: 50, left: 50, top: 5.0, bottom: 5.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffFFFFFF),
                                  border: Border(
                                      left: BorderSide(
                                        color: _type[idx+10*(_curPage-1)] == "word" ? Color(0xff2D31FA) : (_type[idx+10*(_curPage-1)] == "sentence" ? Color(0xff161D6E) : Color(0xff00BBF0)),
                                        width: 5.0,
                                      ),
                                      right: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      top: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      )
                                  ),
                                  // borderRadius: BorderRadius.circular(15.0),
                                  boxShadow:[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.9),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(2, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          if(_type[idx+10*(_curPage-1)]=='word')
                                            Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 20 / 100,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                    child: Text('단 어 ',
                                                      style: TextStyle(
                                                          fontSize: 20, color: Color(0xff333333), fontWeight: FontWeight.w700
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 50 / 100,
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0,
                                                          ),
                                                        )
                                                    ),
                                                    child: Text( _content[idx+10*(_curPage-1)],
                                                      style: TextStyle(
                                                          fontSize: 18, color: Color(0xff333333)),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ]
                                            )
                                          else
                                            Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: MediaQuery.of(context).size.width * 20 / 100,
                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                    child: Text(_type[idx+10*(_curPage-1)]=='Letter'? '글 자' :'문 장',
                                                      style: TextStyle(
                                                          fontSize: 20, color: Color(0xff333333), fontWeight: FontWeight.w700
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 50 / 100,
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0,
                                                          ),
                                                        )
                                                    ),
                                                    child: Text( _content[idx+10*(_curPage-1)],
                                                      style: TextStyle(
                                                          fontSize: 18 , color: Color(0xff333333)),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                ]
                                            )
                                        ],
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )));
                  },
                  itemCount: totalPage,
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.black,
                      activeColor: Color(0xff4478FF),
                      size: 20.0,
                      activeSize: 20.0
                    )
                  ),
                  // control: SwiperControl(),
                    onIndexChanged: (index) {
                      _curPage = index+1;
                    },
                ),
              ))
            ])))));
  }
}
