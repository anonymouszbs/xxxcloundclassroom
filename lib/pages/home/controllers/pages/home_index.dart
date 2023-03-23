import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:xml/xml.dart';
import 'package:xxxcloundclassroom/config/dataconfig/page_id_config.dart';
import 'package:xxxcloundclassroom/db/databaseHelper.dart';
import 'package:xxxcloundclassroom/libspro/getx_untils.dart';
import 'package:xxxcloundclassroom/pages/audio/routers/audio_page_id.dart';

import '../../../../utils/utils_tool.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomeIndexPage extends StatefulWidget {
  const HomeIndexPage({Key? key}) : super(key: key);

  @override
  State<HomeIndexPage> createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeIndexPage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late String _selectedItem = "";
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: '原理教材',
    ),
    Tab(text: '训练大纲'),
    Tab(text: '技能手册'),
  ];
  List<String> _items = <String>[
    '全部',
    '系统相关',
    '元器件相关',
    '理论相关',
    '操作相关',
    '技术相关',
  ];
  final List<Map<String, dynamic>> books = <Map<String, dynamic>>[
    {'title': '习近平谈治国理政', 'author': '电子书阅读：20章', 'cover': 'img/bg.png'},
    {'title': '毛泽东思想', 'author': '音频资源：15集', 'cover': 'img/bg.png'},
    {'title': '邓小平理论', 'author': '视频资源：585页', 'cover': 'img/bg.png'},
    {'title': '三个代表先进思想', 'author': '其他方式的epub', 'cover': 'img/bg.png'},
  ];

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  Future<Uint8List> _loadFromAssets(String assetName) async {
    final bytes = await rootBundle.load(assetName);
    return bytes.buffer.asUint8List();
  }

  List<String> _paragraphs = [];
  Map<String, String> _images = {};
  void _parseXHTML(xhtml) {
    dom.Document document = parser.parse(xhtml);
    List<dom.Element> paragraphs = document.getElementsByTagName('p');
    for (int i = 0; i < paragraphs.length; i++) {
      dom.Element paragraph = paragraphs[i];
      String text = paragraph.text.trim();
      if (text.isNotEmpty) {
        _paragraphs.add(text);
      }
      List<dom.Element> images = paragraph.getElementsByTagName('img');
      for (int j = 0; j < images.length; j++) {
        dom.Element image = images[j];
        String? src = image.attributes['src'];
        _images[src!] = text;
      }
    }
    log(_images.toString());
  }

  a() async {
    var textpath = "img/人为何需要音乐.epub"; //这是根目录所在路径 不是全目录

    var truepath = "";
    EpubBook epub = await EpubReader.readBook(_loadFromAssets(textpath));
    truepath = epub.Schema!.ContentDirectoryPath.toString();
    var unzippath = await Utilstool.unZip(textpath);
    truepath = truepath == "" ? unzippath : unzippath + "/" + truepath;

    var epubBook = epub.Chapters!;
    //  epubBook.map((e) => print(e.Title)).toList();
    final content = epubBook[6].HtmlContent!;

    _parseXHTML(content);

    List data = Utilstool.jxxhtml(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await a();
        
            // print(DatabaseHelper().queryReadBookTakeDown());
            List<Map<String, Object?>>? map =
                await DatabaseHelper().queryReadBookTakeDown();
            print(map![0]);
          },
          child: Icon(Icons.search),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: tabController,
                  tabs: myTabs,
                  indicator: BoxDecoration(
                    color: Color(0xffD5EEEE),
                  ),
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TabBarView(
                controller: tabController,
                children: myTabs.map((Tab tab) {
                  final String? label = tab.text;
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10.w),
                    children: [
                      SizedBox(
                        height: 30.h,
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: _items.map((String item) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedItem = item;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _selectedItem == item
                                      ? Colors.blue.withAlpha(300)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _selectedItem == item
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Text(item),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                              height: 120,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      BotToast.showLoading();
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        currentToPage(
                                            PageIdConfig.readerbookpage);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        _buildBookCover(books[index]),
                                        SizedBox(width: 16),
                                        _buildBookInfo(books[index]),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      currentToPage(AudioBookPageId.details);
                                    },
                                    child: Row(
                                      children: [
                                        _buildBookCover(books[index + 1]),
                                        SizedBox(width: 16),
                                        _buildBookInfo(books[index + 1]),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      currentToPage(PageIdConfig.videoplay);
                                    },
                                    child: Row(
                                      children: [
                                        _buildBookCover(books[index + 2]),
                                        SizedBox(width: 16),
                                        _buildBookInfo(books[index + 2]),
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          VocsyEpub.setConfig(
                                            themeColor:
                                                Theme.of(context).primaryColor,
                                            identifier: "iosBook",
                                            scrollDirection: EpubScrollDirection
                                                .ALLDIRECTIONS,
                                            allowSharing: true,
                                            enableTts: true,
                                            nightMode: true,
                                          );

/**
 * @bookPath
 * @lastLocation (optional and only android)
 */
                                          VocsyEpub.openAsset(
                                            'img/人为何需要音乐.epub',
                                            lastLocation: EpubLocator.fromJson({
                                              "bookId": "2239",
                                              "href": "/OEBPS/ch06.xhtml",
                                              "created": 1539934158390,
                                              "locations": {
                                                "cfi":
                                                    "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                                              }
                                            }), // first page will open up if the value is null
                                          );
                                          //                     Navigator.push(
                                          // context,
                                          // MaterialPageRoute<dynamic>(
                                          //   builder: (_) => const PDFViewerFromUrl(
                                          //     url: 'http://www.leomay.com/upload/file/mmo-20170707165001.pdf',
                                          //   ),
                                          // ),);
                                        },
                                        child: Row(
                                          children: [
                                            _buildBookCover(books[index + 3]),
                                            SizedBox(width: 16),
                                            _buildBookInfo(books[index + 3]),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }

  Widget _buildBookCover(Map<String, dynamic> book) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(book['cover']),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildBookInfo(Map<String, dynamic> book) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            book['title'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // SizedBox(height: 4),
          Text(
            book['author'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '已有30人学习',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '我的完成度：10%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            height: 22.h,
            width: 130.w,
            child: MaterialButton(
              padding: EdgeInsets.all(2),
              onPressed: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 22.sp,
                    color: Colors.white,
                  ),
                  Text(
                    '加入书架',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minWidth: 100,
              height: 48,
            ),
          )
        ],
      ),
    );
  }
}
