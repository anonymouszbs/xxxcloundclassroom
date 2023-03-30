import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/controller.dart';
import 'package:xxxcloundclassroom/utils/sp_util.dart';
import 'package:xxxcloundclassroom/utils/utils_tool.dart';

import '../DisplayConfig.dart';
import 'Selectabletextcontroller.dart';
import 'pagebreaker.dart';

DisplayConfig config = DisplayConfig.getDefault();

class TextPage extends StatelessWidget {
  bool selectTrue = false;
  final YdPage? ydPage;

  TextPage({Key? key, this.ydPage}) : super(key: key);



  
  //   int backgroundColor = Get.isDarkMode?0xFF555555:0xfff5f5f5;//阅读背景色
  // double textSize = 18;//正文字体大小
  // int textColor = Get.isDarkMode?0xFFFFFFFF:0xff000000;//正文字体颜色
  // double titleSize = 24;//标题大小
  // int titleColor = Get.isDarkMode?0xFFFFFFFF:0xff000000;//标题颜色

  var textStyle = TextStyle(
    //color: Color(config.textColor),
    fontSize: config.textSize,
    fontWeight: config.isTextBold == 1 ? FontWeight.bold : FontWeight.normal,
    fontFamily: config.fontPath,
    height: config.lineSpace,
  );
  var titleStyle = TextStyle(
    // color: Color(config.titleColor),
    fontSize: config.titleSize,
    fontWeight: config.isTitleBold == 1 ? FontWeight.bold : FontWeight.normal,
    fontFamily: config.fontPath,
  );

  List<TextSpan> getSpans(String text, String keyword) {
    // 如果文本中不包含关键字，则直接返回原始文本
    if (!text.contains(keyword)) {
      return [TextSpan(text: text)];
    }
    // 将文本按照关键字分割成多个子字符串
    final parts = text.split(keyword);
    final result = <TextSpan>[];
    // 递归地对每个子字符串进行分割
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (i < parts.length - 1) {
        // 如果当前子字符串不是最后一个，则在结果列表中添加分割符和当前子字符串，并设置红色样式
        result.add(TextSpan(text: part));
        result.add(TextSpan(text: keyword, style: TextStyle(color: Colors.red)));
      } else {
        // 如果当前子字符串是最后一个，则递归地对它进行分割，并将结果添加到结果列表中
        final subspans = getSpans(part, keyword);
        result.addAll(subspans);
      }
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    if (ydPage == null) {
      return const Center(
        child: Text(''),
      );
    }

    String text =
        ydPage!.titleString != "" ? ydPage!.text! : ydPage!.text!.trim();
    
    List<TextSpan> textspan = [];

    if(SpUtil.getString(Utilstool.bokkkey)==''){
      textspan.add(TextSpan(text: text));
    }else{
    List str = SpUtil.getString(Utilstool.bokkkey)!.split("|");
    for (var i = 0; i <str.length ; i++) {
      if(text.contains(str[i])){
        textspan.add(TextSpan(text: text.split(str[i])[0]));
         textspan.add(TextSpan(text: str[i],style:const TextStyle(decoration: TextDecoration.underline,
              decorationColor: Colors.red)));
        textspan.add(TextSpan(text: text.split(str[i])[1]));
        break;
      }
    }
    }
    if(textspan.isEmpty){
      textspan.add(TextSpan(text: text));
    }
    
    //textspan.add(TextSpan(text: text));
   


    // text.split("研究生").map((e){
    //   textspan.add(e);
    // }).toList();
    print("我是大傻逼");
    return Stack(
      children: [
        ydPage!.image == null
            ? SizedBox(
                height: ScreenUtil().screenHeight,
                child: SelectableText.rich(
                  TextSpan(
                      children: textspan
                          .map(
                            (e) => e,
                          )
                          .toList()),
                  style: textStyle,
                  selectionControls: MyTextSelectionControls(),
                  onTap: () {
                    print("嗨嗨");
                    selectTrue
                        ? null
                        : ReadController.current.readWidgetKey.currentState!
                            .showTopOrBottom();
                    if (ReadController
                            .current.readWidgetKey.currentState!.leftUIisopen ==
                        true) {
                      ReadController.current.readWidgetKey.currentState!
                          .showLeftUI(context);
                    }
                  },
                  onSelectionChanged: (d, b) {
                    if (b == SelectionChangedCause.longPress) {
                      selectTrue = true;
                    } else {
                      selectTrue = false;
                    }
                  },
                ),
              )
            : Container(
                height: ScreenUtil().screenHeight,
                padding: EdgeInsets.only(
                    left: config.marginLeft,
                    top: config.marginTop,
                    right: config.marginRight,
                    bottom: config.marginBottom),
                child: Image.file(
                  File(ydPage!.image!),
                  fit: BoxFit.fill,
                )),
        ydPage!.titleString! != ""
            ? Positioned(
                top: ydPage!.titleoffset,
                child: Text(
                  ydPage!.titleString!,
                  style: titleStyle,
                ),
              )
            : Container()
      ],
    );
  }
}
