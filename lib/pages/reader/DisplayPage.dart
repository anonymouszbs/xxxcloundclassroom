
import 'package:flutter/material.dart';

import '../../compents/common_widgets.dart';
import 'DisplayConfig.dart';
import 'PageBreaker.dart';
import 'TextPage.dart';


//单双页，页眉页脚，左右中间间距
class DisplayPage extends StatelessWidget{
  static const STATUS_LOADING = 11;
  static const STATUS_ERROR = 12;
  static const STATUS_SUCCESS = 13;


  final int status;
  final YDPage? text;
  final YDPage? text2;
  final int? chapterIndex;
  final int? currPage;
  final int? maxPage;
  final int? viewPageIndex;//指代在pagerView里面的序号
  final bool? fromEnd;
  final String? errorMsg;

  DisplayPage(this.status, this.text,{this.text2, this.chapterIndex, this.currPage, this.maxPage, this.viewPageIndex, this.fromEnd,this.errorMsg}):super(key: ValueKey(text));

  @override
  Widget build(BuildContext context) {
    var config = DisplayConfig.getDefault();
    return Container(
      color: Color(config.backgroundColor),
      child: Stack(
        children: [
          if(status == STATUS_SUCCESS)
            _buildContent(context),
          if(status == STATUS_LOADING)
            Container(
              child: Center(//占位内容
                child: Text('第一次加载中',style: TextStyle(color: Color(config.textColor)),),
              ),
            ),
          if(status == STATUS_ERROR)
            _buildError(),
        ],
      ),
    );
  }

  Widget _buildError(){
    var config = DisplayConfig.getDefault();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('加载失败/(ㄒoㄒ)/~~\n$errorMsg',style: TextStyle(color: Color(config.textColor)),maxLines: 6,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
          VSpace(20),
          IconButton(onPressed: (){
          //  通过viewPageIndex标识更新
          },icon: Text('重新加载'),)
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context){
    var config = DisplayConfig.getDefault();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: config.marginLeft,top: config.marginTop,right: config.marginRight,bottom: config.marginBottom),
          child:_buildTextPage(config)
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6,right: 14),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text('$currPage/$maxPage',style: TextStyle(color: Colors.grey),),
          ),
        )

      ],
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
          
          Expanded(child: Text(text!.titlePainter!.toString())),
          HSpace(config.inSizeMargin),
          Expanded(child: TextPage(ydPage: text2,)),
        ],
      );
    }
  }

}