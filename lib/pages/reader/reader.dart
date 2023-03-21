import 'dart:developer';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/readercontroller.dart';
import 'package:xxxcloundclassroom/utils/utils_tool.dart';

import 'DisplayConfig.dart';
import 'PageBreaker.dart';

class ReaderBookPage extends StatefulWidget {
  final dirPath;
  const ReaderBookPage({Key? key, this.dirPath}) : super(key: key);

  @override
  State<ReaderBookPage> createState() => _ReaderBookPageState();
}

class _ReaderBookPageState extends State<ReaderBookPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late List<EpubChapter> epubBook;
  late EpubContent _epubController;
  late DisplayConfig config;
  List<YDPage> page = [];
  int statescode = 12; //状态吗 12loading 13sucess
  Size size = Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight);
  @override
  void initState() {
    config = DisplayConfig.getDefault();
    ReaderController.current.size =
        Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight);
    initcontent();
    super.initState();
    BotToast.closeAllLoading();
  
  }

  @override
  void dispose() {
    ReaderController.current.closeAppbar();
    super.dispose();
  }



  initcontent() async {
    EpubBook epub = await EpubReader.readBook(await Utilstool.loadFromAssets("img/人为何需要音乐.epub","byte"));

    EasyLoading.removeAllCallbacks();
    ReaderController.current.init(epubChapter: epub);
    if (ReaderController.current.dh != true) {
      AnimationController animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      AnimationController animationController1 = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      AnimationController animationController2 = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      ReaderController.current.leftUIanimationController = animationController2;
      ReaderController.current.topUIanimationController = animationController;
      ReaderController.current.bottomUIanimationController =
          animationController1;
    }
    setState(() {
      statescode = 13;
    });
  }




  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: null,
        body: OrientationBuilder(builder: ((context, orientation) {
          if (size.width != ScreenUtil().screenWidth) {
            size = Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight);
            initcontent();
          }

          return GestureDetector(
         
            onTap: () {
              ReaderController.current.initstate(context);
              ReaderController.current.leftUIisopen == true
                  ? ReaderController.current.leftUIanimationController
                      .animateTo(0)
                  : ReaderController.current.leftUIanimationController
                      .animateTo(0);
              ReaderController.current.leftUIisopen = false;
            },
            child: Stack(
              children: [
                statescode == 13
                    ? PageView.custom(
                        //physics: NeverScrollableScrollPhysics(),
                        scrollDirection: config.isVertical == 1
                            ? Axis.vertical
                            : Axis.horizontal,
                        pageSnapping: config.isVertical != 1,
                        childrenDelegate:
                            SliverChildBuilderDelegate((ctx, index) {
                          return Obx(() =>
                              ReaderController.current.chapaterpage[index]);
                        }, childCount: 99999999),
                        controller: ReaderController.current.pageviewcontroller,
                        onPageChanged: (i) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            ReaderController.current.scrollpageListen(i);
                          });
                        },
                      )
                    : Container(),
                    Positioned(
                      left: 0,
                      child: InkWell(
                          onTap: (){
                                      ReaderController.current.pageviewcontroller
                            .previousPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInSine);
                          },
                        child:Container(
                          
                        alignment: Alignment.topLeft,
                        height: ScreenUtil().screenHeight,
                        width: 200,
                        
                    ))),
                     Positioned(
                      right:0 ,
                      child: InkWell(
                          onTap: (){
                                      ReaderController.current.pageviewcontroller
                            .nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInSine);
                          },
                        child:Container(
                         
                        alignment: Alignment.topRight,
                        height: ScreenUtil().screenHeight,
                        width: 200,
                        
                    )))
               
              ],
            ),
          );
        })));
  }

  @override
  bool get wantKeepAlive => false;
}
