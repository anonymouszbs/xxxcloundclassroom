import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xxxcloundclassroom/libspro/getx_untils.dart';
import 'package:xxxcloundclassroom/pages/audio/routers/audio_page_id.dart';

class AudioBookDetailPage extends StatefulWidget {
  const AudioBookDetailPage({Key? key}) : super(key: key);

  @override
  State<AudioBookDetailPage> createState() => _AudioBookDetailPage();
}

class _AudioBookDetailPage extends State<AudioBookDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  AudioPlayer audioPlayer = AudioPlayer();
  String url =
      "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3";
  PlayerState _playerState = PlayerState.paused;
  Duration d = Duration(milliseconds: 1), p = Duration(milliseconds: 1);
  double speedposition = 0.01;
  int time = 2;
  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    _animationController.dispose();
    
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )
      ..forward()
      ..addStatusListener((status) {
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
        } else if (status == AnimationStatus.forward) {
          print("status is forward");
          //执行 controller.forward() 会回调此状态
        } else if (status == AnimationStatus.reverse) {
          //执行 controller.reverse() 会回调此状态
          print("status is reverse");
        }
      });

    audioPlayer
      ..onPlayerStateChanged.listen((PlayerState state) {
        _playerState = state;
        if (_playerState == PlayerState.playing) {
          _animationController.repeat();
        } else {
          _animationController.stop();
        }
        setState(() {});
        //这里是监听播放状态，是否播放
      })
      ..onPositionChanged.listen((Duration p) {
        setState(() {
          this.p = p;
          print(p.inMilliseconds / d.inMilliseconds);
          speedposition = double.parse(
              (this.p.inMilliseconds / d.inMilliseconds)
                  .toString()
                  .substring(0, 4));
        });
        //这里是监听播放进度
      })
      ..onPlayerComplete.listen((event) {
        //播放完毕后触发
        setState(() {
          _animationController.stop();
        });
      })
      ..onDurationChanged.listen((d) {
        setState(() {
          this.d = d;
        });
      });

    init();
  }

  init() async {
    await audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('听书详情页面'),
        ),
        body: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 上半部分：书介绍
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "img/bg.png",
                        fit: BoxFit.fitWidth,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '《三体》',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '刘慈欣 / 朗读者：陈道明',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '《三体》是刘慈欣所著的科幻小说，讲述了人类文明和外星文明的对抗故事。本书获得了“雨果奖”等多个国际奖项。',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 下半部分：集数列表
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text('${index + 1}'),
                          title: Text('第 ${index + 1} 集'),
                          trailing: Icon(Icons.play_arrow),
                          onTap: () {
                            currentToPage(AudioBookPageId.play);
                            // TODO: 点击播放事件
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 40,
                    width: ScreenUtil().screenWidth,
                    child: AppBar(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                              Hero(
                                  tag: "boo1l.png",
                                  child: SizedBox(
                                    width: 40,
                                    height:40,
                                    child: RotationTransition(
                                      alignment: Alignment.center,
                                      turns: _animationController,
                                      child: const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "http://p2.music.126.net/4uiy7t752A4HHF2bwqVj1A==/109951164812388197.jpg?param=140y140"),
                                      ),
                                    ),
                                  )),
                            ]),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${p.toString().substring(0,7)}/${d.toString().substring(0,7)}"),  
                          Expanded(
                            child: Slider(
                              
                              value:speedposition,
                              max: 1,
                              min: 0,
                              onChanged: (value) {},
                              activeColor: Colors.white,
                            ),
                          ),
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    color:
                                        Colors.grey.shade200.withOpacity(0.5),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.fast_rewind,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ))),
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    color:
                                        Colors.grey.shade200.withOpacity(0.5),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ))),
                          SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    color:
                                        Colors.grey.shade200.withOpacity(0.5),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.fast_forward,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {},
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
