import 'package:get/route_manager.dart';
import 'package:xxxcloundclassroom/pages/audio/audioDetails.dart';
import 'package:xxxcloundclassroom/pages/audio/bookinfo.dart';
import 'package:xxxcloundclassroom/pages/audio/routers/audio_page_id.dart';

class AudioBookPages {
  

  static final routers = [
    GetPage(name: AudioBookPageId.details, page: ()=> AudioBookDetailPage()),
    GetPage(name: AudioBookPageId.play, page: ()=>BookInfo())
  ];
}