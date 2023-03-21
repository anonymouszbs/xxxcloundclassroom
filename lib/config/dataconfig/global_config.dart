


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    ///初始化腾讯tbs
  //  var isInit = await FilePreview.tbsHasInit();
  //   if (!isInit) {
  //       await FilePreview.initTBS();
  //       return;
  //   }
    //初始化自动布局
    /// 配置通用 loading 时长
    EasyLoading.instance.displayDuration = const Duration(
      milliseconds: 1500,
    );
  }
  /// 初始化默认数据
  static initnormaldata() async {
    if (Utilstool.islogin()) {
      UserModel model = UserModel.fromMap(CommonSpUtil.getUserInfo()!);
      UserStateController.current.loadSucess(model);
    }
  }
}