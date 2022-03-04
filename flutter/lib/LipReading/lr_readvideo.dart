import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class ReadingVideo extends StatefulWidget {
  const ReadingVideo({Key? key}) : super(key: key);

  @override
  _ReadingVideoState createState() => _ReadingVideoState();
}

class _ReadingVideoState extends State<ReadingVideo> {
  double _videoSpeed = 1.0;
  late VideoPlayerController _controller;
  File? _video;
  final picker = ImagePicker();
  _pickVideo() async{
    final video = await picker.pickVideo(source: ImageSource.gallery);
    _video=File(video!.path);
    _controller=VideoPlayerController.file(_video!)..initialize().then((_) =>{
      setState((){}),
      _controller.play(),
    _controller.setLooping(true)
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
      appBar: AppBar(
        title: Text('영상으로 연습하기', style: TextStyle(
            color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
            ),
        centerTitle: true,
        backgroundColor: Color(0xffC8E8FF),
      ),
      body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
        children: [
          if(_video != null)...{
          //   Container(
          //     height: 600,
          //     child: _controller.value.isInitialized? AspectRatio(
          // aspectRatio: _controller.value.aspectRatio,
          // child: ConstrainedBox(
          //   constraints: BoxConstraints(
          //     minHeight: 200,
          //     maxHeight: 600
          //   ),
          // child: VideoPlayer(_controller)
          // )
            _controller.value.isInitialized? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
            child: Container(
              child: VideoPlayer(_controller),
            )
            ): Container(),
            Padding(padding: EdgeInsets.all(2.0)),
            Row(
              //동영상 플레이 버튼
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(left: 1.0)),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding:
                          EdgeInsets.only(right: 5.0, left: 5.0),
                          primary: Color(0xffC8E8FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_left_sharp,
                          size: 37,
                          color: Color(0xff97D5FE),
                        ),
                        onPressed: () {}),
                  ],
                ),
                Padding(padding: EdgeInsets.all(3.0)),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffC8E8FF),
                        minimumSize: Size(45, 37),
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 21,
                        color: Color(0xff97D5FE),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(right: 130.0)),
                Container(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_videoSpeed > 0.25) {
                            _videoSpeed -= 0.25;
                          }
                        });
                        _controller.setPlaybackSpeed(_videoSpeed);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffC8E8FF),
                        minimumSize: Size(40, 35),
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 20,
                        color: Color(0xff97D5FE),
                      ),
                    )),
                Padding(padding: EdgeInsets.only(right: 8.0)),
                Container(
                  child: Text('$_videoSpeed'),
                  width: 30,
                ),
                Container(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_videoSpeed < 1.5) {
                            _videoSpeed += 0.25;
                          }
                        });
                        _controller.setPlaybackSpeed(_videoSpeed);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffC8E8FF),
                        minimumSize: Size(40, 35),
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xff97D5FE),
                      ),
                    )),
              ],
            ),
          }
          else...{
            Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.height/5),),
            Container(
              alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff97D5FE),
                padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
              ),
              onPressed: (){
                _pickVideo();
              },
              child: Text('갤러리에서 동영상 불러오기'),
            )
          )
          }
        ],
      ),
    )),
    onWillPop: (){
          setState(() {
            _controller.pause();
          });
          return Future(()=>true);
    },);
  }
}
