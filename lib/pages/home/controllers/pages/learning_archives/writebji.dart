import 'package:flutter/material.dart';
import 'package:xxxcloundclassroom/db/databaseHelper.dart';


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
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bijiListData!.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text("${index+1}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          title:Row(children: [
             Text(bijiListData![index]['bookname'].toString()),
             SizedBox(width: 10,),
              Expanded(child: Text(bijiListData![index]['bookcontent'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1 ,style: TextStyle(color: Colors.grey),),)
          ],),
          subtitle: Text('我的感想：${bijiListData![index]['takedown']}',style: TextStyle(color: Colors.green),),
        );
      },
    
    );
  }
}