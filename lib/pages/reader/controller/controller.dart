

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:xxxcloundclassroom/config/controller/user_state_controller.dart';
import 'package:xxxcloundclassroom/config/models/readbook_model.dart';
import 'package:xxxcloundclassroom/config/models/user_model.dart';

import '../../../db/databaseHelper.dart';

class ReadController extends GetxController{
  static ReadController get current => Get.find<ReadController>();
  Rx<String> title = "".obs;
  Rx<double> fontsize = 25.0.obs;
  Rx<String> inputText = ''.obs;
  int bookindex  = 0;
  late BuildContext context;
  saveWrite(code)async{
  showDialog(
      context: context,
      builder: (BuildContext context) {
      
      return AlertDialog(
          title: Text('请写下自己的想法'),
          content: TextField(
            maxLines: 5,
            onChanged: (value) {
              inputText.value = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
              Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确定'),
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
        );
    });}
}