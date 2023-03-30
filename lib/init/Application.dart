
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xxxcloundclassroom/config/controller/user_state_controller.dart';
import 'package:xxxcloundclassroom/main.dart';
import 'package:xxxcloundclassroom/utils/utils_tool.dart';

import '../config/dataconfig/routers/routers.dart';
import '../utils/theme_tool.dart';

class Application extends StatelessWidget {

  Application({Key? key}) : super(key: key);
  //final easyLoading = EasyLoading.init();
  final bottoast  = BotToastInit();
  //final bottoast = BotToastInit();
  ///全局单击事件
  globalOnTap(){
    

  }
  @override
  Widget build(BuildContext context) {
   
    return ScreenUtilInit(
      designSize:  const Size(1080, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (content,child){
        return GestureDetector(
          onTap: () => globalOnTap(),
          child: GetMaterialApp(
            initialRoute: Utilstool.configrootpageid(),
            getPages: Routers.getAllRouts(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) { 
              //easyLoading(context, child);s
              return MediaQuery(
              //设置文字大小不随系统设置改变
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: bottoast(context, child),
            );},
            theme: ThemeData(brightness: Brightness.light,),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: Themetool.getlocalprofileaboutThemeModel(),
            initialBinding: AllControllerBinding(),
          ),
        );
      },
    );
  }
}