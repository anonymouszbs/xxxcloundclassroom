import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xxxcloundclassroom/compents/video/video.dart';
import 'package:xxxcloundclassroom/config/dataconfig/page_id_config.dart';
import 'package:xxxcloundclassroom/pages/audio/routers/audio_routers.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/nav_home_page.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/routers/home_routers.dart';
import 'package:xxxcloundclassroom/pages/login/routers/login_routers.dart';

import '../../../pages/reader/reader.dart';

class Routers{
  static List<GetPage> getAllRouts(){
    return [
      ..._normalGroupRoutes(),
      ...HomePages.routers,
      ...LoginPages.routers,
      ...AudioBookPages.routers
    ];
  }

  ///默认界面路由数据
  static List<GetPage> _normalGroupRoutes(){
    return [
      GetPage(name: PageIdConfig.home, page: ()=>const NavHomePage()),
      GetPage(name: PageIdConfig.webviewpag, page: ()=>  Container()),
     GetPage(name: PageIdConfig.readerbookpage, page: ()=> const ReaderPage()),
      GetPage(name: PageIdConfig.videoplay, page: ()=> const VideoPlayScreen()),
      GetPage(name: PageIdConfig.loadOhter, page: ()=>const ReaderPage())
    ];
  }
}