import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class LipReadingList {
  final String type;
  final String content;
  final int probId;

  LipReadingList(this.type, this.content, this.probId);
}

class lrCustomProblemListPage extends StatefulWidget {

  final List<LipReadingList> lipReadingList;

  const lrCustomProblemListPage({Key? key, required this.lipReadingList}) : super(key: key);

  @override
  State<lrCustomProblemListPage> createState() => _customProblemListPageState();
}

class _customProblemListPageState extends State<lrCustomProblemListPage> {

  int _curPage=1;
  late int totalPage = widget.lipReadingList.length%10 == 0 ? widget.lipReadingList.length~/10: widget.lipReadingList.length~/10+1;

  @override
  void initState() {
    // print(_probId[0].toString() + ' ' + _type[0] + ' ' + _content[0]);
    super.initState();
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
                stops: [0.3, 0.7, 0.9,],
              ),
            ),
            child: SafeArea(
                child: Container(
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        height: 40.0,
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
                                "커스텀 문제: 구화",
                                style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
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
                                              _curPage==totalPage ? widget.lipReadingList.length-(_curPage-1)*10 : 10,
                                                  (idx) => Container(
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    print(widget.lipReadingList[idx].probId);
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
                                                            widget.lipReadingList[idx].type == 'Word'
                                                                ? '단어' + ' - ' + widget.lipReadingList[idx+10*(_curPage-1)].content
                                                                : '문장' + ' - ' + widget.lipReadingList[idx+10*(_curPage-1)].content,
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
                    ]
                    )
                )
            )
        )
    );
  }
}
