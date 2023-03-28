import 'dart:developer';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:xxxcloundclassroom/pages/reader/DisplayConfig.dart';

import 'analyzer_html.dart';
import 'controller/controller.dart';
import 'itempage/DisplayPage.dart';
import 'itempage/animations.dart';
import 'itempage/globalvar_config.dart';
import 'dart:ui' as ui;

import 'itempage/pagebreaker.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({Key? key}) : super(key: key);

  @override
  State<ReaderPage> createState() => ReaderPageState();
}

class ReaderPageState extends State<ReaderPage> with TickerProviderStateMixin {
  DisplayConfig config = DisplayConfig.getDefault();
  PageController pageController = PageController();
  List<YdPage> page = [];
  List<Map<dynamic, List>> chapters = [];
  List index = [];

  ///这个是什么不言而喻，就是获取章节对应的页面
  int currentindex = 0;
  int chapterCurrentIndex = 0;

  ///现在所选择的章节

  List currentChapters = []; //记录章节对应数组
  List currentChapterpages = [];
  //导航
  //阅读器导航小说
  bool topUIisopen = false, bottomUIisopen = false, leftUIisopen = false;
  bool _topUIopen = false, _bottomUIopen = false, _leftUIopen = false;
  bool dh = false;
  late OverlayEntry topUIoverlayEntry, bottomUIoverlayEntry, leftUIoverlayEntry;
  late AnimationController topUIanimationController;
  late AnimationController bottomUIanimationController;
  late AnimationController leftUIanimationController;
  //初始化值
  late EpubBook epub;
  late String bookUZpath;

  bool showloading = true;

  //控制滑动
  bool neverscroll = false;
  @override
  void initState() {
    // TODO: implement initState
    //初始化控制器
    BotToast.closeAllLoading();
    initController();
    super.initState();
    ReadController.current.context = context;
    init();
  }

  @override
  void dispose() {
     
    if (_bottomUIopen == true) {
      topUIoverlayEntry.remove();
      bottomUIoverlayEntry.remove();
      if (_leftUIopen == true) {
        leftUIoverlayEntry.remove();
      }
    }
    super.dispose();
  }

  initController() {
    AnimationController animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    AnimationController animationController1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    AnimationController animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    leftUIanimationController = animationController2;
    topUIanimationController = animationController;
    bottomUIanimationController = animationController1;
  }

  init() async {
    String bookpath = "img/人为何需要音乐.epub";
    epub = await EpubReader.readBook(
        await Ctr.loadFromAssets(bookpath, "byte")); //读取epub
    bookUZpath = await Ctr.gettruepath(
        rootpath: epub.Schema!.ContentDirectoryPath.toString(),
        bookpath: bookpath); //获取解压后的epub真目录
    ReadController.current.title.value =
        epub.Chapters![chapterCurrentIndex].Title!;
    var pagebreake = await Ctr().spilit(
        epub: epub.Chapters![chapterCurrentIndex], bookUZpath: bookUZpath);
    for (var a = 0; a < (pagebreake.length / 2).ceil().toInt(); a++) {
      int realIndex = a * 2;
      DisPlayPage disPlayPage = DisPlayPage(1, pagebreake[realIndex],
          realIndex > pagebreake.length - 2 ? null : pagebreake[realIndex + 1]);

      chapters.add({
        disPlayPage: [chapterCurrentIndex, a]
      });
    }

    currentChapters.add(chapterCurrentIndex);
    currentChapterpages.add(chapters.length);

    showloading = false;

    setState(() {});
  }

  //加载上一章节
  loadPreviewChapter() async {
    int chapterCurrentIndex1 = currentChapters[0];
    if (chapterCurrentIndex1 - 1 < 0) {
      BotToast.showText(text: "已是第一章");
      return;
    } else {
      chapterCurrentIndex1--;
    }

    var pagebreake = await Ctr().spilit(
        epub: epub.Chapters![chapterCurrentIndex1], bookUZpath: bookUZpath);

    List j_chapter = [];

    for (var a = 0; a < (pagebreake.length / 2).ceil().toInt(); a++) {
      int realIndex = a * 2;
      j_chapter.add(DisPlayPage(
          1,
          pagebreake[realIndex],
          realIndex > pagebreake.length - 2
              ? null
              : pagebreake[realIndex + 1]));
    }
    j_chapter = List.from(j_chapter.reversed);

    for (var i = 0; i < j_chapter.length; i++) {
      chapters.insert(0, {
        j_chapter[i]: [chapterCurrentIndex1, i]
      });
    }

    currentChapters.insert(0, chapterCurrentIndex1);
    currentChapterpages.add(chapters.length);
    currentChapterpages.sort();

    pageController.jumpToPage(j_chapter.length);

    setState(() {});
  }

  //加载下一章节
  loadNextChapter() async {
    int chapterCurrentIndex1 = currentChapters[currentChapters.length - 1];
    if (chapterCurrentIndex1 + 1 > epub.Chapters!.length) {
      BotToast.showText(text: "已是最后一章");
      return;
    } else {
      chapterCurrentIndex1++;
    }

    var pagebreake = await Ctr().spilit(
        epub: epub.Chapters![chapterCurrentIndex1], bookUZpath: bookUZpath);

    List j_chapter = [];

    for (var a = 0; a < (pagebreake.length / 2).ceil().toInt(); a++) {
      int realIndex = a * 2;
      j_chapter.add(DisPlayPage(
          1,
          pagebreake[realIndex],
          realIndex > pagebreake.length - 2
              ? null
              : pagebreake[realIndex + 1]));
    }

    for (var i = 0; i < j_chapter.length; i++) {
      chapters.add({
        j_chapter[i]: [chapterCurrentIndex1, i]
      });
    }

    currentChapters.add(chapterCurrentIndex1);
    currentChapterpages.add(chapters.length);
    currentChapterpages.sort();

    setState(() {});
  }

  ///翻页
  scrollpageListen(p) {
    currentindex = p;
    ReadController.current.bookindex = currentindex;
    final values = chapters[p].values.toList();
    ReadController.current.title.value = epub.Chapters![values[0][0]].Title!;
    chapterCurrentIndex = values[0][0];

    if (p == 0) {
      loadPreviewChapter();
    } else if (p == chapters.length - 1) {
      loadNextChapter();
    }

    setState(() {});
  }


changeChapter(index)async{
  currentindex = 0;
  chapterCurrentIndex = index;
  await refesh("change");
  ReadController.current.readWidgetKey.currentState!
                            .showTopOrBottom();
                    if (ReadController
                            .current.readWidgetKey.currentState!.leftUIisopen ==
                        true) {
                      ReadController.current.readWidgetKey.currentState!
                          .showLeftUI(context);
                    }
}

  Future<void> refesh(type) async {
    final values = chapters[currentindex].values.toList();
    var jumptoindex ;
    switch (type) {
      case "change":
        jumptoindex = 0;
        break;

      case "refesh":
        jumptoindex = values[0][1];
        break;
    }
   

    showloading = true;
    chapters.clear(); //清空所有内容
    index.clear(); //清空章节索引
    currentChapterpages.clear(); //清空记录
    currentChapters.clear(); //清空记录

    await init();

    pageController.jumpToPage(jumptoindex);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Color(config.textColor),
      fontSize: config.textSize,
      fontWeight: config.isTextBold == 1 ? FontWeight.bold : FontWeight.normal,
      fontFamily: config.fontPath,
      height: config.lineSpace,
    );
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              // showLeftUI(context);
              print("object");
              if (leftUIisopen == true) {
                showLeftUI(context);
              }
              showTopOrBottom();
            },
            child: showloading
                ? Center(
                    child: Text("加载中"),
                  )
                : Stack(
                    children: [
                      GestureDetector(
                        child: PageView.custom(
                          physics:NeverScrollableScrollPhysics()
                              ,
                          scrollDirection: config.isVertical == 1
                              ? Axis.vertical
                              : Axis.horizontal,
                          pageSnapping: config.isVertical != 1,
                          childrenDelegate:
                              SliverChildBuilderDelegate(((context, index) {
                            var key = chapters[index].keys.toList();

                            return key[0];
                          }), childCount: chapters.length),
                          controller: pageController,
                          onPageChanged: (i) {
                            // int now = DateTime.now().millisecondsSinceEpoch;
                            // if (now - lastBackPressedTime > 3000) {
                            //   lastBackPressedTime = now;
                            // } else {
                            //   neverscroll = true;
                            //   BotToast.showText(text: "别翻太快了,三秒后可翻动");
                            //   Future.delayed(Duration(seconds: 3), () {
                            //     neverscroll = false;
                            //     setState(() {});
                            //   });
                            // }
                            scrollpageListen(i);
                          },
                        ),
                      ),
                      Positioned(
                          right: 5,
                          bottom: 5,
                          child: Text('${currentindex}/${chapters.length}')),
                      Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            height: ScreenUtil().screenHeight,
                            child: InkWell(
                              onTap: () async {
                                if (currentindex == 0) {
                                  await loadPreviewChapter();
                                  pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                }
                              },
                            ),
                          )),
                      Positioned(
                          right: -1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 100,
                            height: ScreenUtil().screenHeight,
                            child: InkWell(
                              onTap: () {
                                int now = DateTime.now().millisecondsSinceEpoch;
                                if (now - lastBackPressedTime > 2000) {
                                  lastBackPressedTime = now;
                                  if (currentindex == chapters.length - 1) {
                                    loadNextChapter();
                                  }
                                  pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  BotToast.showText(text: "别翻太快了");
                                }
                              },
                            ),
                          ))
                    ],
                  )));
  }

  int lastBackPressedTime = 0;
  showTopOrBottom() {
    showbottomUI(context);
    showtopUI(context);
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
                    //返回按钮
                    Get.back();
                  },
                  icon: const Icon(Icons.chevron_left)),
              title: Obx(() => Text(ReadController.current.title.value)),
              
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
                      onPressed: () {
                        ///切换主题色
                        
                        if (Get.isDarkMode) {
                          Get.changeTheme(ThemeData.light());
                         
                        } else {
                          Get.changeTheme(ThemeData.dark());
                          
                        }
                      },
                      icon: Icon(Get.isDarkMode
                          ? Icons.brightness_4
                          : Icons.brightness_5)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  AlertDialog(
                                  title: Text('字体设置'),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                       Expanded(child: InkWell(
                                        onTap: (){
                                          config.textSize = 22;
                                          refesh("refesh");
                                          Get.back();
                                        },
                                        child:Icon(Icons.text_format,size: 30,)),
                                      ),
                                       Expanded(child:InkWell(
                                        onTap: (){
                                          config.textSize = 18;
                                          refesh("refesh");
                                           Get.back();
                                        },
                                        child:  Icon(Icons.text_format,size: 25,)),
                                      ),
                                         Expanded(child:InkWell(
                                        onTap: (){
                                          config.textSize = 16;
                                          refesh("refesh");
                                           Get.back();
                                        },
                                        child: Icon(Icons.text_format,size: 20,)),
                                      ),
                                        Expanded(child:InkWell(
                                        onTap: (){
                                          config.textSize = 12;
                                          refesh("refesh");
                                           Get.back();
                                        },
                                        child:  Icon(Icons.text_format,size: 18,)),
                                      ),
                                    ],
                                  ),
                                );
                          },
                        );
                      },
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
              itemCount: epub.Chapters!.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      ///切换章节
                      changeChapter(index);
                    },
                    child: ListTile(
                      title: Text(epub
                          .Chapters![index].Title!), //Text(itemschatgpt[index])
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

class Ctr {
  DisplayConfig config = DisplayConfig.getDefault();

  ///加载asset资源
  static loadFromAssets(String assetName, String type) async {
    final bytes = await rootBundle.load(assetName);
    switch (type) {
      case "image":
        final image = await decodeImageFromList(bytes.buffer.asUint8List());
        return image;
      case "byte":
        return bytes.buffer.asUint8List();
    }
  }

  Future<List<YdPage>> spilit(
      {required EpubChapter epub, required bookUZpath}) async {
    String content = epub.HtmlContent!;
    List<String> image = await getimageList(content, bookUZpath);

    log(image.toString());
    content = AnalyzerHtml.getHtmlString(content).replaceAll("\n\n", "\n");
    content =
        content.replaceAllMapped(RegExp(r'<img\s+[^>]*>'), (match) => "☏");

    List<YdPage> str = PageBreaker(
            generateTitleTextSpan(epub.Title!),
            generateContentTextSpan(content),
            generateTextPageSize(
                Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight)),
            image)
        .splitPage();
    log(str.length.toString());
    return str;
  }

  ///加载本地资源
  static loadFromLocal(String path, String type) async {
    final bytes = await File(path).readAsBytes();
    switch (type) {
      case "image":
        final image = await decodeImageFromList(bytes);
        return image;
      case "byte":
        return bytes.buffer.asUint8List();
    }
  }

  Future<List<String>> getimageList(content, bookUZpath) async {
    List data = jxxhtml(content);
    List<String> listimage = [];
    for (var i = 0; i < data.length; i++) {
      listimage.add(bookUZpath + data[i]);
    }
    return listimage;
  }

  static jxxhtml(content) {
    List img = [];

    var document = XmlDocument.parse(content);
    var imgTags = document.findAllElements('img');

    for (var imgTag in imgTags) {
      final src = imgTag.getAttribute('src');
      if (src != null) {
        img.add(src.replaceAll("..", ""));
      }
    }

    return img;
  }

  //标题的样式
  TextSpan generateTitleTextSpan(String title) {
    final titleStyle = TextStyle(
      color: Color(config.titleColor),
      fontSize: config.titleSize,
      fontWeight: config.isTitleBold == 1 ? FontWeight.bold : FontWeight.normal,
      fontFamily: config.fontPath,
    );
    final titleSpan = TextSpan(
      text: title.trim(),
      style: titleStyle,
    );
    return titleSpan;
  }

  //计算分页的大小
  Size generateTextPageSize(size) {
    var textPageSize = Size(size.width - config.marginLeft - config.marginRight,
        size.height - config.marginTop - config.marginBottom); //显示区域减去外边距
    if (config.isSinglePage == 1) {
      //单页
      return textPageSize;
    } else {
      //双页
      return Size(
          (textPageSize.width - config.inSizeMargin) / 2, textPageSize.height);
    }
  }

  TextSpan generateContentTextSpan(String chapterContent) {
    final textStyle = TextStyle(
      color: Color(config.textColor),
      fontSize: config.textSize,
      fontWeight: config.isTextBold == 1 ? FontWeight.bold : FontWeight.normal,
      fontFamily: config.fontPath,
      height: config.lineSpace,
    );

    final textSpan = TextSpan(
      text: chapterContent,
      style: textStyle,
    );
    return textSpan;
  }

  static gettruepath({required rootpath, bookpath}) async {
    var unzippath = await unZip(bookpath);
    var truepath = rootpath == "" ? unzippath : unzippath + "/" + rootpath;
    log(truepath);
    return truepath;
  }
  //解压获得真实路径

  static unZip(zippath) async {
    final tempDir = await getTemporaryDirectory();
    final extractionPath = Directory('${tempDir.path}/extraction/folder');
    // 如果解压目录不存在，创建它
    if (!extractionPath.existsSync()) {
      extractionPath.createSync(recursive: true);
    }
    // 读取asset中的zip文件
    final bytes = await rootBundle.load(zippath);
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    for (final file in archive) {
      final filePath = '${extractionPath.path}/${file.name}';
      if (file.isFile) {
        final data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(filePath)..create(recursive: true);
      }
    }
    // 获取解压后的路径
    final extractedFolderPath = extractionPath.path;
    return extractedFolderPath;
  }
}
