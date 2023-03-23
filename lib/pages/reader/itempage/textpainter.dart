import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../DisplayConfig.dart';
import 'Selectabletextcontroller.dart';
import 'pagebreaker.dart';

DisplayConfig config = DisplayConfig.getDefault();

class TextPage extends StatelessWidget {
  final YdPage? ydPage;

  TextPage({Key? key, this.ydPage}) : super(key: key);
  final textStyle = TextStyle(
    color: Color(config.textColor),
    fontSize: config.textSize,
    fontWeight: config.isTextBold == 1 ? FontWeight.bold : FontWeight.normal,
    fontFamily: config.fontPath,
    height: config.lineSpace,
  );
  final titleStyle = TextStyle(
        color: Color(config.titleColor),
        fontSize: config.titleSize,
        fontWeight: config.isTitleBold==1?FontWeight.bold:FontWeight.normal,
        fontFamily: config.fontPath,
    );
  @override
  Widget build(BuildContext context) {
    if (ydPage == null) {
      return const Center(
        child: Text(''),
      );
    }

    return
       Stack(
        children: [
           ydPage!.image == null
        ? SizedBox(height: ScreenUtil().screenHeight,child: SelectableText(
            ydPage!.titleString!=""?ydPage!.text!:ydPage!.text!.trim(),
            style: textStyle,
           
           selectionControls: MyTextSelectionControls(),
            
          ),)
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

            ydPage!.titleString! !=""?Positioned( top: ydPage!.titleoffset, child: Text(ydPage!.titleString!,style: titleStyle,),):Container()
        ],
       );
         
  }
}
