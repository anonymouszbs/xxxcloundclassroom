

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:xxxcloundclassroom/config/controller/user_state_controller.dart';
import 'package:xxxcloundclassroom/config/models/readbook_model.dart';
import 'package:xxxcloundclassroom/config/models/user_model.dart';
import 'package:xxxcloundclassroom/pages/reader/DisplayConfig.dart';

import '../../../db/databaseHelper.dart';
import '../reader.dart';


class ReadController extends GetxController{
  static ReadController get current => Get.find<ReadController>();
  GlobalKey<ReaderPageState> readWidgetKey = GlobalKey<ReaderPageState>();
  Rx<String> title = "".obs;
  Rx<double> fontsize = DisplayConfig.getDefault().textSize.obs;
  Rx<String> inputText = ''.obs;
  int bookindex  = 0;
  late BuildContext context;
  saveWrite(code)async{
  if(readWidgetKey.currentState!.topUIisopen == true && readWidgetKey.currentState!.bottomUIisopen == true){
    readWidgetKey.currentState!.showTopOrBottom();
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
      
      return AlertDialog(
        titlePadding: EdgeInsets.all(0),
        actionsPadding:EdgeInsets.all(0) ,
        contentPadding: EdgeInsets.all(0),
          title: Text('添加笔记'),
          content: TextField(
            maxLines: 4,
            onChanged: (value) {
              
              inputText.value = value;
            },
          ),
          actions: <Widget>[
           Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ 
              TextButton(
              child: Text('取消'),
              onPressed: () {
              Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('保存'),
              onPressed: () async{
                // 在这里进行相应的操作，比如将输入的内容显示出来
                print('输入的内容为：${inputText.value.toString()}');
                ReadBookTakeDownModel readBookTakeDownModel = ReadBookTakeDownModel(surname: UserStateController.current.user.surname,workPermitNum: UserStateController.current.user.workPermitNum,bookname: "习近平谈治国理政",bookindex: bookindex.toString(),takedown: inputText.value.toString(),bookcontent:code );
                await DatabaseHelper().insertReadBookTakeDownModel(readBookTakeDownModel); 
                BotToast.showText(text: "已保存");
               Navigator.of(context).pop();
              },
            ),
            ],
           ))
          ],
        );
    });}
}