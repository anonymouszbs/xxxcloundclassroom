

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'writebji.dart';


class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> with SingleTickerProviderStateMixin{
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
      text: '学习任务',
    ),
    Tab(text: '个人书架'),
    Tab(text: '读书笔记'),
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





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
           

          
          },
          child: Icon(Icons.add),
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
                  if(label=="读书笔记"){
                    return BijiPage();
                  }
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10.w),
                    children: [
                       
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
                                          
                                            print("dd");

                            
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