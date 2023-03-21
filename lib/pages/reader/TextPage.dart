import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xxxcloundclassroom/pages/reader/DisplayConfig.dart';
import 'package:xxxcloundclassroom/pages/reader/textUtils.dart';

import 'PageBreaker.dart';

/// 显示文字的页面，单页，已分页
class TextPage extends StatelessWidget {
  final YDPage? ydPage;
  DisplayConfig config = DisplayConfig.getDefault();

  TextPage({this.ydPage}) : super(key: ValueKey(ydPage));
  @override
  Widget build(BuildContext context) {
    if (ydPage == null) {
      return Center(
        child: Text(''),
      );
    }
    return CustomPaint(
      painter: YDPainter(ydPage!),
    );
  }
}

class YDPainter extends CustomPainter {
  final YDPage ydPage;

  YDPainter(this.ydPage);

  @override
  void paint(Canvas canvas, Size size) {
    var jsize = Size((ScreenUtil().screenWidth / 2) - config.inSizeMargin,
        ScreenUtil().screenHeight);
    var page = ydPage;
    var titleOffset = Offset(0, 0);
    Paint paint = Paint();
    if (page.titlePainter != null) {
      page.titlePainter?.paint(canvas, Offset.zero);
      titleOffset = Offset(0, page.titleOffset);
    }
     page.pagePainter.paint(canvas, titleOffset);
    // double scale = (100 / page.image![0].width).clamp(0.0, 1.0);
    // double width = page.image![0].width.toDouble() * scale;
    // double height = page.image![0].height.toDouble() * scale;
    // canvas.drawImageNine(
    //     page.image![0],
    //     Rect.fromLTWH(0, 0, 20, 20),
    //     Rect.fromLTWH(
    //         60, 200, ScreenUtil().screenWidth / 2 - config.inSizeMargin, 200),
    //     Paint());
   
      if(page.image!=null){
        
      }

    print(page.imgTop);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
