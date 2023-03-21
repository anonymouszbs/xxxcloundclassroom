import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:xxxcloundclassroom/config/controller/user_state_controller.dart';
import 'package:xxxcloundclassroom/config/dataconfig/page_id_config.dart';
import 'package:xxxcloundclassroom/pages/login/routers/login_page_id.dart';
import 'package:xxxcloundclassroom/utils/common_sp_util.dart';


class Utilstool{
  //判断为什么操作系统




///加载本地资源
static loadFromLocal(String path,String type)async{
  final bytes = await File(path).readAsBytes();
  switch (type) {
    case "image":
      final image = await decodeImageFromList(bytes);
      return image;
    case "byte":
      return bytes.buffer.asUint8List();
  }
}

///加载asset资源
static   loadFromAssets(String assetName,String type) async {
  final bytes = await rootBundle.load(assetName);
  switch (type) {
    case "image":
      final image = await decodeImageFromList(bytes.buffer.asUint8List());
      return image;
    case "byte":
      return bytes.buffer.asUint8List();
  }
    
    
  }
///解压epub
static unZip(zippath)async{
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

///解析xhtml
  static jxxhtml(content){
    List data = [];
    List img = [];
    String p = "";
  var document = XmlDocument.parse(content);
  var imgTags = document.findAllElements('img');
  
  for (var imgTag in imgTags) {
    final src = imgTag.getAttribute('src');
    if (src != null) {
      img.add(src.replaceAll("..", ""));
    }
  }
  document = XmlDocument.parse(content);
  final textTags = document.descendants.where((node) =>
      node is XmlElement &&
      (node.name.local == 'p' ||node.name.local== 'img'||
          node.name.local.startsWith('h') ||
          node.name.local == 'li'));
  for (var textTag in textTags) {
    final text = textTag.text.trim();
    if (text.isNotEmpty) {
      p+=text;
    }
  }
  
  data = [p,img];
  return data;
  }

  getOSType(){
    if (Platform.isWindows) {
      return "win";
    } else if (Platform.isMacOS) {
      return "mac";
    }
  }
  ///判断是否登录
  static islogin(){
    bool islogin = true;
    String? token = CommonSpUtil.getUserToken();
    if(token==null||token==""){
      islogin=false;
    }
    print(islogin);
    return islogin;

  }
  ///配置程序入口
  static configrootpageid(){
    String rootroute = PageIdConfig.home;
    int intal = CommonSpUtil.getfirstinstal();
    if(intal==0&&!islogin()){
      rootroute = LoginPageId.login;

    }else if(!islogin()){
      rootroute = LoginPageId.login;

    }
    return rootroute;
  }
}