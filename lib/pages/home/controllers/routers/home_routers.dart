import 'package:get/get.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/home_bottom_navigatorbar.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/home_index.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/routers/home_page_id.dart';

class HomePages{
  HomePages._();
  static final routers = {
    GetPage(name: HomePageId.home,page: ()=>const HomeIndexPage()),
    GetPage(name: HomePageId.homebottomnavigator, page:()=> HomeBottmNavigatorBar())
  };
}