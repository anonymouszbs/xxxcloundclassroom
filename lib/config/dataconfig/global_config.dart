


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:xxxcloundclassroom/utils/utils_tool.dart';

import '../../utils/common_sp_util.dart';
import '../../utils/sp_util.dart';
import '../controller/user_state_controller.dart';
import '../models/user_model.dart';


class GloblConfig{
  static init()async{
    WidgetsFlutterBinding.ensureInitialized();
    await initthirdparty();
  }
  static initthirdparty()async{
    //初始化数据库
    await SpUtil.getInstance();

    EasyLoading.instance.displayDuration = const Duration(
      milliseconds: 1500,
    );
  }
  /// 初始化默认数据
  static initnormaldata() async {
    SpUtil.clear();
    if (Utilstool.islogin()) {
      UserModel model = UserModel.fromMap(CommonSpUtil.getUserInfo()!);
      UserStateController.current.loadSucess(model);
    }
  }
}