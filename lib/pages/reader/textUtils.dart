import 'package:flutter/material.dart';

import 'DisplayConfig.dart';

DisplayConfig config = DisplayConfig.getDefault();

TextSpan generateContentTextSpan(String chapterContent){
    final textStyle = TextStyle(
      color: Color(config.textColor),
      fontSize: config.textSize,
      fontWeight: config.isTextBold==1?FontWeight.bold:FontWeight.normal,
      fontFamily: config.fontPath,
      height: config.lineSpace,
    );

    final textSpan = TextSpan(
      text: chapterContent,
      style: textStyle,
    );
    return textSpan;
  }

  //标题的样式
  TextSpan generateTitleTextSpan(String title){
    final titleStyle = TextStyle(
        color: Color(config.titleColor),
        fontSize: config.titleSize,
        fontWeight: config.isTitleBold==1?FontWeight.bold:FontWeight.normal,
        fontFamily: config.fontPath,
    );
    final titleSpan = TextSpan(
      text: title.trim(),
      style: titleStyle,
    );
    return titleSpan;
  }

  //计算分页的大小
  Size generateTextPageSize(size){
    var textPageSize = Size(size.width- config.marginLeft - config.marginRight, size.height - config.marginTop - config.marginBottom);//显示区域减去外边距
    if(config.isSinglePage == 1){//单页
      return textPageSize;
    }else{//双页
      return Size((textPageSize.width-config.inSizeMargin)/2,textPageSize.height);
    }
  }
    regCode(htmlcontent) {
    String html = htmlcontent;
    String? pTagContent = "";
    RegExp exp = RegExp(r'<p>(.*?)</p>');
    Iterable<Match> matches = exp.allMatches(html);
    for (Match match in matches) {
      if (match.group(1) != null) {
        pTagContent = "${pTagContent!}${match.group(1)}\n";
      }
    }
    return pTagContent!.replaceAll("\n", "\n");
  }
