import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/controller.dart';

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
  @override
  Widget build(BuildContext context) {
    if (ydPage == null) {
      return const Center(
        child: Text(''),
      );
    }
    String text =  ydPage!.titleString != ""
                      ? ydPage!.text!
                      : ydPage!.text!.trim();
    List<InlineSpan> textspan = [
    ];
    if(text.contains("研究生")){
      textspan.add(TextSpan(text: text.split("研究生")[0],style: textStyle));
    textspan.add(TextSpan(text:"研究生",style: TextStyle(color: Colors.red)));
    textspan.add(TextSpan(text: text.split("研究生")[1],style: textStyle));

    }else{
textspan.add(TextSpan(text: text,style: textStyle));;
    }

    // text.split("研究生").map((e){
    //   textspan.add(e);
    // }).toList();
    
    

    return Stack(
      children: [
        ydPage!.image == null
            ? SizedBox(
                height: ScreenUtil().screenHeight,
                child: SelectableText.rich(
                  TextSpan(
                    children: textspan.map((e) => e,).toList()
                  ),
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
                    if (b!.index == 0) {
                      selectTrue = false;
                    } else {
                      selectTrue = true;
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
