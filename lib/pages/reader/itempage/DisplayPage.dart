import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../DisplayConfig.dart';
import 'pagebreaker.dart';
import 'textpainter.dart';

class DisPlayPage extends StatelessWidget{
  
  final int? status;
  final YdPage? text;
  final YdPage? text2;
  DisPlayPage(this.status,this.text,this.text2);


  @override
  Widget build(BuildContext context) {
    var config = DisplayConfig.getDefault();
    return Container(
      color: Color(config.backgroundColor),
      child: Container(
          padding: EdgeInsets.only(left: config.marginLeft,top: config.marginTop,right: config.marginRight,bottom: config.marginBottom),
          child:_buildTextPage(config)
        ),
    );
  }
   ///显示文字的控件
  Widget _buildTextPage(DisplayConfig config){
    if(config.isSinglePage == 1){//单页
      return TextPage(ydPage: text,);
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TextPage(ydPage: text,)),
         // SizedBox(width: config.inSizeMargin,),
          HSpace(config.inSizeMargin-5),
          Expanded(child: TextPage(ydPage: text2,)),
        ],
      );
    }
  }
}
class HSpace extends StatelessWidget{
  final double width;


  HSpace(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(size: Size(width,0),);
  }
}

