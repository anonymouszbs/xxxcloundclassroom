import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class BookInfo extends StatefulWidget {
  const BookInfo({Key? key}) : super(key: key);
  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> with SingleTickerProviderStateMixin{
  var _value = 0.0;
  AudioPlayer audioPlayer = AudioPlayer();
  String url = "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3";
  PlayerState _playerState = PlayerState.paused;
  Duration d = Duration(milliseconds: 1),p = Duration(milliseconds: 1);
  double speedposition = 0.01;
  int time = 2;
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    _animationController = AnimationController(
      
      duration:  Duration(seconds: 2),
      vsync: this,
    )..forward()..addStatusListener((status) {

  if (status == AnimationStatus.completed) {
  //动画从 controller.reverse() 反向执行 结束时会回调此方法
  print("status is completed");
  // controller.reset(); 将动画重置到开始前的状态
  //开始执行
  //controller.forward();
  _animationController.repeat();
  } else if (status == AnimationStatus.dismissed) {

  //动画从 controller.forward() 正向执行 结束时会回调此方法
  print("status is dismissed");

  }else if (status == AnimationStatus.forward) {
  print("status is forward");
  //执行 controller.forward() 会回调此状态
  }else if (status == AnimationStatus.reverse) {
  //执行 controller.reverse() 会回调此状态
  print("status is reverse");
  }
 });

    audioPlayer..onPlayerStateChanged.listen((PlayerState state) { 
      _playerState = state;
      if(_playerState ==PlayerState.playing){
        _animationController.repeat();
      }else{
        _animationController.stop();
      }
      setState(() {
        
      });
        //这里是监听播放状态，是否播放
    })..onPositionChanged.listen((Duration p){
      setState(() {
        this.p=p;
        print(p.inMilliseconds/d.inMilliseconds);
        speedposition = double.parse((this.p.inMilliseconds/d.inMilliseconds).toString().substring(0,4));
      });
      //这里是监听播放进度
    })..onPlayerComplete.listen((event) {
      //播放完毕后触发
        setState(() {
           _animationController.stop();
        });
     })..onDurationChanged.listen((d) {

      setState(() {
        this.d = d;
      });
      });

    init();
  }
  init()async{
    await audioPlayer.play(UrlSource(url));
   
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    audioPlayer.dispose();

    
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff100A20),
        body: Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Stack(children: [
                  Hero(
                      tag: "boo1l.png",
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child:  RotationTransition(
      alignment: Alignment.center,
      turns: _animationController,
      child: const CircleAvatar(
        backgroundImage: NetworkImage(
            "http://p2.music.126.net/4uiy7t752A4HHF2bwqVj1A==/109951164812388197.jpg?param=140y140"),
      ),
    ),
                      )),
                ]),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "数据名称",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "书籍作者",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: "montserrat",
                            fontWeight: FontWeight.w600),
                      ),
                      Slider(
                        min: 0,
                        max: 1.0,
                        inactiveColor: Colors.white,
                        activeColor: Colors.orange,
                        value: speedposition,
                        onChanged: (value) {
                         
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(p.toString().substring(0,7),
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          Text(
                            "${d.toString().substring(0,7)}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ))
            ]),
            Positioned(
                bottom: 100,
                left: 0,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.fast_rewind,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    onPressed: () {},
                                  ),
                                )))),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  child: IconButton(
                                    icon:  Icon(
                                     _playerState== PlayerState.playing?Icons.pause:Icons.play_arrow,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    onPressed: () async{
                                      switch (_playerState) {
                                        case PlayerState.playing:
                                        
                                          audioPlayer.pause();
                                          break;
                                        case PlayerState.paused:
                                          audioPlayer.resume();
                                          
                                          break;
                                        case PlayerState.stopped:
                                       
                                          audioPlayer.play(UrlSource(url));
                                          break;     
                                        default:
                                        audioPlayer.play(UrlSource(url));
                                      }
                                    },
                                  ),
                                )))),
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey.shade200.withOpacity(0.5),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.fast_forward,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                    onPressed: () {},
                                  ),
                                ))))
                  ],
                ))
          ],
        ));
  }
}

