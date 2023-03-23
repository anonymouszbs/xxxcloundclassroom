import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import '../DisplayConfig.dart';

class PageBreaker {
  TextSpan contentString;
  TextSpan titleString;
  Size drawSize;
  List<String> image;
  //SelectableTextz selectableText;

  PageBreaker(this.titleString, this.contentString, this.drawSize, this.image);

  int getRegExpLength(txt) {
    final text = txt;
    final pattern = RegExp('☏');
    final matches = pattern.allMatches(text);
    final count = matches.length;
    return count;
  }

  splitPage() {
    //当前页面文字
    int imglength = 0;
    String currentText = "${contentString.text}  ";
    String overText = '';
    List<YdPage> results = [];
    List imgtop = [];
    double qmaybeheight;
    String titlestring = titleString.text!;
    while (currentText.isNotEmpty) {
      TextPainter? titlePainter;
      //计算标题
      if (results.isEmpty) {
        titlePainter = TextPainter(
            text: titleString,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center);
        titlePainter.layout(minWidth: drawSize.width, maxWidth: drawSize.width);
      }
      var titleMargin = DisplayConfig.getDefault().titleMargin; //标题与正文间距
      var titleOffset = titlePainter == null
          ? 0.0
          : titlePainter.height + titleMargin; //如果标题没有高或者有高就用高加上间距

      var maxlength = currentText.length;
      var minlength = 0;
      var maybelength = 0;

      while (true) {
        maybelength = ((maxlength - minlength) / 2).truncate() + minlength;

        var maybeText = currentText.substring(0, maybelength);

        var tempspan = TextSpan(text: maybeText, style: contentString.style);
        var contentPainter = TextPainter(
          text: tempspan,
          textDirection: TextDirection.ltr,
        );

        contentPainter.layout(maxWidth: drawSize.width);

        var maybeheight = contentPainter.height;

        qmaybeheight = maybeheight;

        if (maybeheight >
            drawSize.height - (titlestring != "" ? titleOffset : 0)) {
          maxlength = maybelength;
        } else {
          if (maybeText.contains('☏')) {
            break;
          }
          if (minlength == maybelength) {
            break;
          }
          minlength = maybelength;
        }
      }
      
      overText = currentText.substring(maybelength);

      currentText = currentText.substring(0, maybelength);

      YdPage temppage;

      if (currentText.contains("☏")) {
        List<String> img = [];
        for (var i = 0; i < RegExp('☏').allMatches(currentText).length; i++) {
           img.add(image[imglength++]);
        }
        if(img.length>1){
          currentText = currentText.replaceAll(RegExp('☏'), "");
          overText = currentText + overText;
          temppage = YdPage(titleOffset, titlestring, "`", img[1]);
          results.add(YdPage(titleOffset, titlestring, "`", img[0]));
        }else{
          currentText = currentText.replaceAll(RegExp('☏'), "");
          overText = currentText + overText;
          temppage = YdPage(titleOffset, titlestring, "`", img[0]);
        }
      } else {
        currentText = titlestring != ""
            ? currentText.replaceAll(titlestring, "")
            : currentText;
        temppage = YdPage(titleOffset, titlestring, currentText, null);
      }
      titlestring = "";
      results.add(temppage);
      if(results[results.length-1].text!.trim()==""){
        results.removeAt(results.length-1);
        }

      if (currentText.trim().isEmpty) {
        break;
      }

      

     
      

      currentText = overText;
       
    }

    return results;
  }
}

class YdPage {
  double titleoffset;
  String? titleString;
  String? text;
  String? image;
  YdPage(this.titleoffset, this.titleString, this.text, this.image);
}
