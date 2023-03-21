import '../config/dataconfig/normal_string_config.dart';
import 'sp_util.dart';

class CommonSpUtil{
  //获取token
  
 static String? getUserToken(){
    return SpUtil.getString(NormalFlagIdConfig.usertoken);
  }
  //存用户token
  static saveUserToken({required token}){
    return SpUtil.putString(NormalFlagIdConfig.usertoken, token);
  }
  //获取用户信息
  static Map?getUserInfo(){
    return SpUtil.getObject(NormalFlagIdConfig.userinfo);
  }
  //存用户信息
  static  saveUserInfo({required info}){
    return SpUtil.putObject(NormalFlagIdConfig.userinfo, info);
  }


 //获取app次数
  static int getfirstinstal(){
    return SpUtil.getInt(NormalFlagIdConfig.firstinstal)??0;
  }




  ///主题切换 深色模式 0: 关闭 1: 开启 2: 随系统 
  static int getThemeType() {
    return SpUtil.getInt(NormalFlagIdConfig.themeType) ?? 0;
  }
    /// 存深色模式
  static saveThemeType({required int type}) {
    return SpUtil.putInt(NormalFlagIdConfig.themeType, type);
  }
  ///主题切换结束
  
  ///语言切换 存语言配置 语种
  static saveLauchType({required String launch}) {
    return SpUtil.putString(NormalFlagIdConfig.launchType, launch);
  }

  /// 获取语言配置 语种
  static String getLaunchType() {
    return SpUtil.getString(NormalFlagIdConfig.launchType) ?? "zh_CN";
  }
  //语言切换结束
}