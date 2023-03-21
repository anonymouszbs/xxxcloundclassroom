import 'dart:developer';
import 'dart:ui' as ui;
import 'package:bot_toast/bot_toast.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:xxxcloundclassroom/config/dataconfig/globalvar_config.dart';
import 'package:xxxcloundclassroom/main.dart';
import 'package:xxxcloundclassroom/pages/reader/DisplayConfig.dart';
import 'package:xxxcloundclassroom/pages/reader/DisplayPage.dart';
import 'package:xxxcloundclassroom/pages/reader/PageBreaker.dart';
import 'package:xxxcloundclassroom/utils/analyzer_html.dart';

import '../../../compents/animations.dart';
import '../../../utils/utils_tool.dart';
import '../textUtils.dart';

class ReaderController extends GetxController {
  static ReaderController get current => Get.find<ReaderController>();
  //阅读器导航小说
  bool topUIisopen = false, bottomUIisopen = false, leftUIisopen = false;
  bool _topUIopen = false, _bottomUIopen = false, _leftUIopen = false;
  bool dh = false;
  late OverlayEntry topUIoverlayEntry, bottomUIoverlayEntry, leftUIoverlayEntry;
  late AnimationController topUIanimationController;
  late AnimationController bottomUIanimationController;
  late AnimationController leftUIanimationController;
  late PageController pageviewcontroller = PageController(initialPage: 0);

  ///以下控制阅读器
  DisplayConfig config = DisplayConfig.getDefault();
  List<EpubChapter> _epubChapter = [];
  RxList chapaterpage = [].obs;
  RxInt allindex = 0.obs, currentindex = 0.obs;
  Rx<String> title = "标题".obs;
  Size size = Size(0, 0); //阅读器布局大小

  List index = [];

  newregcode(content) async {
//  var textpath = "img/人为何需要音乐.epub";//这是根目录所在路径 不是全目录
//  var truepath = "";
//  EpubBook epub = await EpubReader.readBook(Utilstool.loadFromAssets(textpath));
//  truepath  = epub.Schema!.ContentDirectoryPath.toString();
//  var unzippath = await Utilstool.unZip(textpath);
//  truepath = truepath==""?unzippath:unzippath+"/"+truepath;

//  print(truepath);

// var epubBook = epub.Chapters!;
//   //  epubBook.map((e) => print(e.Title)).toList();
// final content = epubBook[6].HtmlContent!;

// List data = Utilstool.jxxhtml(content);

// log(data[0].toString());
  }

  init({required EpubBook epubChapter}) async {
    var textpath = "img/人为何需要音乐.epub";
    var truepath = epubChapter.Schema!.ContentDirectoryPath.toString();
    var unzippath = await Utilstool.unZip(textpath);
    truepath = truepath == "" ? unzippath : unzippath + "/" + truepath;

    _epubChapter = epubChapter.Chapters!;

  
     var content =_epubChapter[6].HtmlContent!;
        List data = Utilstool.jxxhtml(content);
        List<ui.Image> listimage= [];

       await data[1].map((e)async{
          print(truepath+e);
          ui.Image image = await Utilstool.loadFromLocal(truepath+e,"image");
          listimage.add(image);
        }).toList();
        

        for (var i = 0; i < data[1].length; i++) {
          ui.Image image = await Utilstool.loadFromLocal(truepath+data[1][i],"image");
          listimage.add(image);
        }

      content = AnalyzerHtml.getHtmlString(_epubChapter[6].HtmlContent!);
      content = content.replaceAllMapped(RegExp(r'<img\s+[^>]*>'), (match) => "");
         ui.Image image = listimage[0];
        var ydpage = PageBreaker(generateContentTextSpan(content), generateTitleTextSpan(_epubChapter[6].Title!), generateTextPageSize(size),listimage,data[1]).splitPage();


    for (var a = 0; a < (ydpage.length / 2).ceil(); a++) {
      int realIndex = a * 2;
      chapaterpage.add(Obx(() => DisplayPage(
            13,
            ydpage[realIndex],
            text2: realIndex > ydpage.length - 2 ? null : ydpage[realIndex + 1],
            chapterIndex: 6,
            currPage: currentindex.value,
            maxPage: allindex.value,
          )));
    }
    index.add(chapaterpage.length);

    BotToast.closeAllLoading();
    allindex.value = chapaterpage.length;
    index.insert(0, 0); //补位
    print(index);
  }

//   init({required EpubBook epubChapter}) async{
//   var textpath = "img/人为何需要音乐.epub";
//  var truepath  = epubChapter.Schema!.ContentDirectoryPath.toString();
//  var unzippath = await Utilstool.unZip(textpath);
//   truepath = truepath==""?unzippath:unzippath+"/"+truepath;

//       _epubChapter = epubChapter.Chapters!;

//       for (var i = 0; i < _epubChapter.length; i++) {

//         var content =_epubChapter[i].HtmlContent!;
//         List data = Utilstool.jxxhtml(content);
//         ui.Image image = await Utilstool.loadFromAssets("img/head.png","image");

//         var ydpage = PageBreaker(generateContentTextSpan(data[0]), generateTitleTextSpan(_epubChapter[i].Title!), generateTextPageSize(size),image).splitPage();
//         for (var a = 0; a < (ydpage.length/2).ceil(); a++) {
//           int realIndex = a*2;
//           chapaterpage.add(
//            Obx(()=> DisplayPage(13, ydpage[a],text2: realIndex>ydpage.length-2?null:ydpage[a+1],chapterIndex: i,currPage:currentindex.value,maxPage: allindex.value,)
//            ) );
//         }
//         index.add(chapaterpage.length);

//       }
//       BotToast.closeAllLoading();
//       allindex.value = chapaterpage.length;
//       index.insert(0,0);//补位
//       print(index);
//   }

  ///翻页
  scrollpageListen(i) {
    currentindex.value = i;
    print(currentindex);
    print(index);
    for (var i = 0; i < index.length; i++) {
      if (index[i] == currentindex.value) {
        title.value = _epubChapter[i].Title!;
        print(title.value);
        break;
      }
    }
  }

  closeAppbar() {
    _epubChapter.clear();
    chapaterpage.clear();
    index.clear();
    allindex.value = 0;
    currentindex.value = 0;
    _topUIopen = true;
    topUIisopen = true;
    _bottomUIopen = true;
    bottomUIisopen = true;
    leftUIisopen = true;
    _leftUIopen = true;
    showLeftUI(context);
    initstate(context);
  }

  setAnimation(ob, context) {
    topUIanimationController = ob;
    bottomUIanimationController = ob;
  }

  initstate(context) {
    showtopUI(context);
    showbottomUI(context);
  }

  showtopUI(context) {
    if (_topUIopen == false) {
      _topUIopen = true;
      topUIisopen = true;
      dh = true;
      show(
          context: context,
          animationController: topUIanimationController,
          tab: readui.top);
    } else {
      topUIisopen == true
          ? topUIanimationController.animateTo(0)
          : topUIanimationController.forward();

      topUIisopen = !topUIisopen;
    }
  }

  showLeftUI(context) {
    if (_leftUIopen == false) {
      _leftUIopen = true;
      leftUIisopen = true;
      show(
          context: context,
          animationController: leftUIanimationController,
          tab: readui.LEFT);
    } else {
      leftUIisopen == true
          ? leftUIanimationController.animateTo(0)
          : leftUIanimationController.forward();

      leftUIisopen = !leftUIisopen;
    }
  }

  showbottomUI(context) {
    if (_bottomUIopen == false) {
      _bottomUIopen = true;
      bottomUIisopen = true;
      show(
          context: context,
          animationController: bottomUIanimationController,
          tab: readui.bottom);
    } else {
      bottomUIisopen == true
          ? bottomUIanimationController.animateTo(0)
          : bottomUIanimationController.forward();
      bottomUIisopen = !bottomUIisopen;
    }
  }

  void show(
      {required BuildContext context,
      required animationController,
      required tab}) {
    switch (tab) {
      case readui.top:
        topUIoverlayEntry = OverlayEntry(builder: (context) {
          return AnimationsPY(
            frame: AppBar(
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.chevron_left)),
              title: Text("标题"),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                        true ? Icons.library_books : Icons.chrome_reader_mode)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.headset))
              ],
            ),
            animationController: animationController,
            tab: tab,
          );
        });
        Overlay.of(context)?.insert(topUIoverlayEntry);
        break;
      case readui.bottom:
        bottomUIoverlayEntry = OverlayEntry(builder: (context) {
          return AnimationsPY(
            frame: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        showLeftUI(context);
                      },
                      icon: const Icon(Icons.format_align_left_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_attributes_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.brightness_5_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.translate_outlined)),
                ],
              ),
            ),
            animationController: animationController,
            tab: tab,
          );
        });
        Overlay.of(context)?.insert(
          bottomUIoverlayEntry,
        );
        break;
      case readui.LEFT:
        leftUIoverlayEntry = OverlayEntry(builder: (context) {
          return AnimationsPY(
            frame: ListView.separated(
              itemCount: _epubChapter.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      pageviewcontroller.jumpToPage(this.index[index]);
                    },
                    child: ListTile(
                      title: Text(_epubChapter[index]
                          .Title!), //Text(itemschatgpt[index])
                    ));
              },
            ),
            animationController: animationController,
            tab: tab,
          );
        });
        Overlay.of(context)?.insert(
          leftUIoverlayEntry,
        );
        break;
      default:
    }

    //延时两秒，移除 OverlayEntry
    //  Future.delayed(Duration(seconds: 20)).then((value) {
    //   overlayEntry.remove();
    // });
  }
}
