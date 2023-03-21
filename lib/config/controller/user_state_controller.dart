import 'package:get/get.dart';
import 'package:xxxcloundclassroom/compents/common_widgets.dart';
import 'package:xxxcloundclassroom/config/models/user_model.dart';
import 'package:xxxcloundclassroom/db/databaseHelper.dart';
import 'package:xxxcloundclassroom/libspro/getx_untils.dart';
import 'package:xxxcloundclassroom/pages/login/routers/login_page_id.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/readercontroller.dart';
import 'package:xxxcloundclassroom/utils/common_sp_util.dart';

import '../dataconfig/global_config.dart';

class UserStateController extends GetxController{
  static UserStateController get current => Get.find<UserStateController>();

  final Rx<UserModel> _currentUser = UserModel().obs;
  UserModel get user=> _currentUser.value;

  static bool get isLogin => current.user.surname!=null;

  //登录完成
  loadSucess(UserModel model)async{

    CommonSpUtil.saveUserToken(token: model.surname??"");

    CommonSpUtil.saveUserInfo(info: model.toMap());

    await DatabaseHelper().insertUserModel(model);
    _currentUser.value = model;
  }
  //退出登录
  void exitLoginSucess(){
    CommonSpUtil.saveUserToken(token: "");
    _currentUser.value = UserModel();
    showtoastmsg("退出成功",ontap: (){
      currentToPage(LoginPageId.login);
    });
  }
  
}
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<UserStateController>(
      UserStateController(),
      permanent: true,
    );
    Get.put<ReaderController>(
      ReaderController(),
      permanent: true,
    );
    
    GloblConfig.initnormaldata();
  }
}