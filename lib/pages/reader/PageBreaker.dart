import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'DisplayConfig.dart';


///指定显示区域宽高
///对于长文本进行分页（二分法）
///配置字体等属性
class PageBreaker{
  //正文
  TextSpan contentString;
  //章节标题
  TextSpan titleString;
  //绘制区域大小
  Size drawSize;

 List <ui.Image>? image;
  List? srcimg;
  PageBreaker(this.contentString, this.titleString, this.drawSize,this.image,this.srcimg);

  List<YDPage> splitPage(){
    print(drawSize.width);
    List<YDPage> results = [];
    //当前页面的文字
    String currText = '${contentString.text!} ';//二分缺失的bug，干脆添个空格
    //剩余文字
    String overText = '';
    List imgTop = []; 
    int page = 0;
    while(currText.isNotEmpty){
      TextPainter? titlePainter;
      //计算标题
      if(results.isEmpty){
        titlePainter = TextPainter(text: titleString,textDirection: TextDirection.ltr,textAlign: TextAlign.center);
        titlePainter.layout(minWidth:drawSize.width,maxWidth: drawSize.width);
      }
      var titleMargin = DisplayConfig.getDefault().titleMargin; //标题与正文间距
      var titleOffset = titlePainter==null?0.0:titlePainter.height + titleMargin;//如果标题没有高或者有高就用高加上间距
      //计算内容
      var maxIndex = currText.length;
      var minIndex = 0;
      var maybeIndex = 0;
      //二分得出最后需要截取的位置  相当于直接分页了 
      while(true){//maxIndex-minIndex > 1
        maybeIndex = ((maxIndex - minIndex)/2).truncate() + minIndex;//
        var maybeText = currText.substring(0,maybeIndex); //
       
        //用painter计算他的宽和高
        var tempSpan = TextSpan(text: maybeText,style: contentString.style);
        var contentPainter = TextPainter(text: tempSpan,textDirection: TextDirection.ltr,);

        contentPainter.layout(maxWidth: drawSize.width);
        var maybeHeight = contentPainter.height;

        if(maybeText.contains("●")){
          maybeHeight = maybeHeight+200;
          
        }
       
        
        if(maybeHeight > drawSize.height - titleOffset){//超过了限制高度
          maxIndex = maybeIndex;
        }else{//没超过
          if(minIndex == maybeIndex){
            break;
          }
          minIndex = maybeIndex;

        }
      }
      overText = currText.substring(maybeIndex);
      currText = currText.substring(0,maybeIndex);
      if(currText.trim().isEmpty){
        break;
      }
      // developer.log('-----------------------------------');
      // developer.log(currText);
      // developer.log('-----------------------------------');
      var textPainter = TextPainter(text: TextSpan(text: currText,style: contentString.style),textDirection: TextDirection.ltr,);
      
      textPainter.layout(maxWidth: drawSize.width);
      
      
    
    var tempPage ;
   
    

      if(currText.contains("●")){
       
       tempPage =  YDPage(titleOffset,titlePainter, textPainter,image![page++],imgTop);
      }else{
       tempPage =  YDPage(titleOffset,titlePainter, textPainter,null,null);
      }
      results.add(tempPage);
      
      currText = overText;
    }
    page = 0;
    return results;
  }


}

class YDPage{
  //只有第一页会有的标题
  double titleOffset = 0;
  TextPainter? titlePainter;
  TextPainter pagePainter;
   ui.Image? image;
  List? imgTop;
  YDPage(this.titleOffset, this.titlePainter, this.pagePainter,this.image,this.imgTop);
}