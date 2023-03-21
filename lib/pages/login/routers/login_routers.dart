import 'package:get/route_manager.dart';
import 'package:xxxcloundclassroom/pages/login/pages/login_index.dart';
import 'package:xxxcloundclassroom/pages/login/routers/login_page_id.dart';

class LoginPages {
  

  static final routers = [
    GetPage(name: LoginPageId.login, page: ()=>const LoginIndexPage())
  ];
}