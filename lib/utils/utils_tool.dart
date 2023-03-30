import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:xxxcloundclassroom/config/controller/user_state_controller.dart';
import 'package:xxxcloundclassroom/config/dataconfig/page_id_config.dart';
import 'package:xxxcloundclassroom/pages/login/routers/login_page_id.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/controller.dart';
import 'package:xxxcloundclassroom/utils/common_sp_util.dart';
import 'package:xxxcloundclassroom/utils/sp_util.dart';


class Utilstool{
  
 ///保存需要划线的字 以后优化删掉本段代码
 
 static const String bokkkey = "保存记录key";
 
 static savebookkey(text)async{

  String str = SpUtil.getString(bokkkey)!;
  if(str==''){
    SpUtil.putString(bokkkey, text);
  }else{
    SpUtil.putString(bokkkey, "$str|$text");
  }

  ReadController.current.shuaxin();
 }

 ///判断为什么操作系统
  getOSType(){
    if (Platform.isWindows) {
      return "win";
    } else if (Platform.isMacOS) {
      return "mac";
    }
  }
  ///判断是否登录
  static islogin(){
    bool islogin = true;
    String? token = CommonSpUtil.getUserToken();
    if(token==null||token==""){
      islogin=false;
    }
    print(islogin);
    return islogin;

  }
  ///配置程序入口
  static configrootpageid(){
    String rootroute = PageIdConfig.home;
    int intal = CommonSpUtil.getfirstinstal();
    if(intal==0&&!islogin()){
      rootroute = LoginPageId.login;

    }else if(!islogin()){
      rootroute = LoginPageId.login;

    }
    return rootroute;
  }
}