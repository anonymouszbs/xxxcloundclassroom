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
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with TickerProviderStateMixin {
  DisplayConfig config = DisplayConfig.getDefault();
  PageController pageController = PageController();
  List<YdPage> page = [];
  List chapters = [];
  List index = [];

  ///这个是什么不言而喻，就是获取章节对应的页面
  int currentindex = 0;
  int chapterCurrentIndex = 0;
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

  @override
  void initState() {
    // TODO: implement initState
    //初始化控制器
    BotToast.closeAllLoading();
    initController();
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    if (bottomUIisopen == true) {
      topUIanimationController.dispose();
      bottomUIanimationController.dispose();
      topUIoverlayEntry.dispose();
      bottomUIoverlayEntry.dispose();
      if (leftUIisopen == true) {
        leftUIanimationController.dispose();
        leftUIoverlayEntry.dispose();
      }
    }
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

    for (var i = 0; i < epub.Chapters!.length; i++) {
      var pagebreake =
          await Ctr().spilit(epub: epub.Chapters![i], bookUZpath: bookUZpath);

      for (var a = 0; a < (pagebreake.length / 2).ceil().toInt(); a++) {
        int realIndex = a * 2;
        chapters.add(DisPlayPage(
            1,
            pagebreake[realIndex],
            realIndex > pagebreake.length - 2
                ? null
                : pagebreake[realIndex + 1]));
      }
      index.add(chapters.length);
    }
    index.insert(0, 0); //补位
    ReadController.current.title.value = epub.Chapters![0].Title!;
    // var pagebreake =
    //       await Ctr().spilit(epub: epub.Chapters![6], bookUZpath: bookUZpath);

    //   for (var a = 0; a < (pagebreake.length / 2).ceil().toInt(); a++) {
    //     int realIndex = a * 2;
    //     chapters.add(DisPlayPage(
    //         1,
    //         pagebreake[realIndex],
    //         realIndex > pagebreake.length - 2
    //             ? null
    //             : pagebreake[realIndex + 1]));
    //   }
    showloading = false;

    setState(() {});
  }

  Future<void> refesh() async {
    
    chapters.clear();
    setState(() {
      
    });
    Future.delayed(Duration(microseconds: 300),()async{
      index.clear();
      await init();
    });
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
                      PageView.custom(
                        scrollDirection: config.isVertical == 1
                            ? Axis.vertical
                            : Axis.horizontal,
                        pageSnapping: config.isVertical != 1,
                        childrenDelegate:
                            SliverChildBuilderDelegate(((context, index) {
                          return chapters[index];
                        }), childCount: chapters.length),
                        controller: pageController,
                        onPageChanged: (i) {
                          scrollpageListen(i);
                        },
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
                              onTap: () {
                                pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
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
                                pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              },
                            ),
                          ))
                    ],
                  )));
  }

  showTopOrBottom() {
    showbottomUI(context);
    showtopUI(context);
  }

  ///翻页
  scrollpageListen(i) {
    currentindex = i;
    print(currentindex);
    print(index);
    for (var i = 0; i < index.length; i++) {
      if (index[i] == currentindex) {
        ReadController.current.title.value = epub.Chapters![i].Title!;
        print(ReadController.current.title.value);
        break;
      }
    }
    setState(() {});
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
              // actions: [
              //   IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //           true ? Icons.library_books : Icons.chrome_reader_mode)),
              //   IconButton(onPressed: () {}, icon: const Icon(Icons.headset))
              // ],
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
                        print("object");
                        if(Get.isDarkMode){
                          Get.changeTheme(ThemeData.light());
                          config.textColor = 0xff000000;
                          config.titleColor = 0xff000000;
                          config.backgroundColor = 0xfff5f5f5;
                        }else{
                          Get.changeTheme(ThemeData.dark());
                          config.textColor = 0xFFFFFFFF;
                          config.titleColor = 0xFFFFFFFF;
                          config.backgroundColor = 0xFF555555;
                        }
                     
                        refesh();
                        
                      },
                      icon:  Icon(Get.isDarkMode?Icons.brightness_4:Icons.brightness_5)),
                  IconButton(
                      onPressed: () {
                         showDialog(
              context: context,
              builder: (BuildContext context) {
                return Obx(()=> AlertDialog(
                  title: Text('字体设置'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          config.textSize > 12 ? config.textSize -= 1.0: config.textSize=12;
                          ReadController.current.fontsize.value = config.textSize;
                          refesh();
                        },
                        child: Text('-', style: TextStyle(fontSize: 32.0)),
                      ),
                      Text(ReadController.current.fontsize.toString(), style: TextStyle(fontSize: 20.0)),
                      InkWell(
                        onTap: () {
                          config.textSize > 12 ? config.textSize += 1.0: config.textSize=12;
                          ReadController.current.fontsize.value = config.textSize;
                          refesh();
                        },
                        child: Text('+', style: TextStyle(fontSize: 32.0)),
                      ),
                    ],
                  ),
                ));
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
                      pageController.jumpToPage(this.index[index]);
                      //跳转章节
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
