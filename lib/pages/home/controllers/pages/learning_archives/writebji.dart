import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xxxcloundclassroom/config/dataconfig/page_id_config.dart';
import 'package:xxxcloundclassroom/db/databaseHelper.dart';
import 'package:xxxcloundclassroom/libspro/getx_untils.dart';
import 'package:xxxcloundclassroom/pages/reader/controller/controller.dart';


class BijiPage extends StatefulWidget {
  const BijiPage({super.key});

  @override
  State<BijiPage> createState() => _BijiPageState();
}

class _BijiPageState extends State<BijiPage> {
 List<Map<String, Object?>>?  bijiListData  = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initdata();
  }
  //初始化获取数据
  initdata()async{
    bijiListData =  await DatabaseHelper().queryReadBookTakeDown();
    log(bijiListData.toString());
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return bijiListData!.isEmpty?Text('无数据'):ListView.builder(
      itemCount: bijiListData!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            ReadController.current.initChapterIndex = int.parse(bijiListData![index]['bookchapter'].toString()) ; //要写成方法放在控制器里 不然很难受
            ReadController.current.initbookindex = int.parse(bijiListData![index]['bookindex'].toString()) ;
            currentToPage(PageIdConfig.readerbookpage);
          },
          child: ListTile(
          leading: Text("${index+1}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          title:Row(children: [
             Text(bijiListData![index]['bookname'].toString()),
             SizedBox(width: 10,),
              Expanded(child: Text(bijiListData![index]['bookcontent'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey),),)
          ],),
          subtitle: Text('我的感想：${bijiListData![index]['takedown']}',style: TextStyle(color: Colors.green),),
        ),
        );
      },
    
    );
  }
}