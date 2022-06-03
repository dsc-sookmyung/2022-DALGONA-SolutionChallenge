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
                            padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                      children: [
                        ...List.generate(
                          _curPage==totalPage ? _content.length-(_curPage-1)*10 : 10,
                          (idx) => Container(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                print(_probId[idx]);
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height*7.5/100,
                                margin: EdgeInsets.only(right: 40, left: 40),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.blueGrey),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _type[idx] == 'word'
                                            ? '단어' + ' - ' + _content[idx+10*(_curPage-1)]
                                            : '문장' + ' - ' + _content[idx+10*(_curPage-1)],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff333333)),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                  control: SwiperControl(),
                    onIndexChanged: (index) {
                      _curPage = index+1;
                    },
                ),
              ))
            ])))));
  }
}
