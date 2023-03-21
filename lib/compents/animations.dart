import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xxxcloundclassroom/config/dataconfig/globalvar_config.dart';

class AnimationsPY extends StatefulWidget {
  //平移动化
  final frame;
  final animationController;
  final tab;

  const AnimationsPY(
      {Key? key,
      required this.frame,
      required this.animationController,
      required this.tab})
      : super(key: key);

  @override
  State<AnimationsPY> createState() => _AnimationsPYState();
}

class _AnimationsPYState extends State<AnimationsPY>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tab) {
      case readui.bottom:
        return Container(
          alignment: Alignment.bottomCenter,
          child: SizeTransition(
              axis: Axis.vertical,
              sizeFactor: CurvedAnimation(
                  parent: widget.animationController,
                  curve: Curves.easeInToLinear),
              child: Material(
                  child: SizedBox(
                width: ScreenUtil().screenWidth,
                height: 50,
                child: Center(
                  child: widget.frame,
                ),
              ))),
        );
      case readui.top:
        return Container(
            alignment: Alignment.topCenter,
            //padding: EdgeInsets.only(top:40),
            child: SizeTransition(
                axis: Axis.vertical,
                sizeFactor: CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInToLinear),
                child: Material(
                    child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.transparent.withGreen(150))
                    ],
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  width: ScreenUtil().screenWidth,
                  height: 50,
                  child: Center(
                    child: widget.frame,
                  ),
                ))));
      case readui.RIGHT:
       return  Container(
            alignment: Alignment.topRight,
            child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInBack),
                child: Material(
                   color: Colors.transparent,
                    child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3))],
                  
                  ),
                  width: 200,
                  height: ScreenUtil().screenHeight,
                  child: Center(
                    child: widget.frame,
                  ),
                ))));

        break;
      default:
        return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 50),
            child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInBack),
                child: Material(
                    child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.blue.withAlpha(100))],
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  width: 200,
                  height: ScreenUtil().screenHeight - 100,
                  child: Center(
                    child: widget.frame,
                  ),
                ))));
    }
  }
}
