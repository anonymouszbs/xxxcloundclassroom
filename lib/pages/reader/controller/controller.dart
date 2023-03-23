

import 'package:get/get.dart';

class ReadController extends GetxController{
  static ReadController get current => Get.find<ReadController>();
  Rx<String> title = "".obs;
  Rx<double> fontsize = 25.0.obs;
}