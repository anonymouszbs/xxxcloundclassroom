// ignore: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:xxxcloundclassroom/compents/keepalive.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/home_index.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/honorAndexamination/honor.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/honorAndexamination/test.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/learning_archives/study.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/onlineText/onlineText.dart';

class HomeBottmNavigatorBar extends StatefulWidget {
  const HomeBottmNavigatorBar({Key? key}) : super(key: key);

  @override
  State<HomeBottmNavigatorBar> createState() => _HomeBottmNavigatorBar();
}

class _HomeBottmNavigatorBar extends State<HomeBottmNavigatorBar> {
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int currentindex = 0;
  IconData iconData = Icons.phonelink_erase_rounded;//显示联网图标;
  final List items = [
    {"探索发现": Icons.search},
    {"学习档案": Icons.verified_user},
    {"荣誉室": Icons.border_all},
    {"在线考试": Icons.book_online}
  ];

  final pages = [
    KeepLivepage(
      frame: HomeIndexPage(),
    ),
    KeepLivepage(
      frame: StudyPage(),
    ),
    KeepLivepage(
      frame: HonorPage(),
    ),
    KeepLivepage(
      frame: ExamPage(),
    )
  ];
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();

    //监测是否联网
    Timer.periodic(Duration(milliseconds: 2000), (timer) {
      addlistenwifi();
     });
  }
  void addlistenwifi()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        iconData = Icons.settings_input_hdmi;
        break;
      case ConnectivityResult.ethernet:
        iconData = Icons.settings_input_hdmi;
        break;  
      case ConnectivityResult.wifi:
        iconData = Icons.wifi;
        break;   
      case ConnectivityResult.none:
        iconData = Icons.phonelink_erase_outlined;
        break;     
      default:
        iconData = Icons.close;
    }
    setState(() {
      print(connectivityResult);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.h,
        title: Row(
          children: [
            Icon(Icons.cloud_done),
            Container(
              padding: EdgeInsets.only(left: 10.w),
              child: Text('xxx云课堂'),
            )
          ],
        ),
        actions: [
          IconButton(onPressed: (){

          }, icon:Icon(iconData)),
          IconButton(onPressed: (){

          }, icon:Image.asset("img/head.png"))
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: StylishBottomBar(
        items: items.asMap().keys.map((e) {
          var keys =
              items[e].keys.toString().replaceAll("(", "").replaceAll(")", "");
          return AnimatedBarItems(
              icon: Icon(items[e][keys]),
              selectedColor: Colors.deepPurple,
              backgroundColor: Colors.amber,
              title: Text(keys));
        }).toList(),
        iconSize: 32,

        barAnimation: BarAnimation.fade,
        iconStyle: IconStyle.animated,
        //    iconStyle: IconStyle.simple,
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        opacity: 0.3,
        currentIndex: currentindex,
        barStyle: BubbleBarStyle.vertical,
        bubbleFillStyle: BubbleFillStyle.outlined,
        onTap: (index) {
          setState(() {
            currentindex = index!;
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
