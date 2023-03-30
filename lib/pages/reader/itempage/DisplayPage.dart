import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/controller.dart';

import '../DisplayConfig.dart';
import 'pagebreaker.dart';
import 'textpainter.dart';


class DisPlayPage extends StatefulWidget {
  final bool? bol;
  final int? status;
  final YdPage? text;
  final YdPage? text2;
  
  const DisPlayPage(this.status, this.text, this.text2, this.bol);

  @override
  State<DisPlayPage> createState() => _DisPlayPageState();
}

class _DisPlayPageState extends State<DisPlayPage> {
  @override
  Widget build(BuildContext context) {
    var config = DisplayConfig.getDefault();
    return  Container(
      child: widget.bol==true? Stack(
        children: [
          Container(
          padding: EdgeInsets.only(left: config.marginLeft,top: config.marginTop,right: config.marginRight,bottom: config.marginBottom),
          child:_buildTextPage(config)
        ),
       
        ],
      ):Stack(
        children: [
          Container(
          padding: EdgeInsets.only(left: config.marginLeft,top: config.marginTop,right: config.marginRight,bottom: config.marginBottom),
          child:_buildTextPage(config)
        ),
        ]
      )
    );
  }
   ///显示文字的控件
  Widget _buildTextPage(DisplayConfig config){
    if(config.isSinglePage == 1){//单页
      return TextPage(ydPage: widget.text,);
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child:  TextPage(ydPage: widget.text,)),
         // SizedBox(width: config.inSizeMargin,),
          HSpace(config.inSizeMargin-5),
          Expanded(child: TextPage(ydPage: widget.text2,)),
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

