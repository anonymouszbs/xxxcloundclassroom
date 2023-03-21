import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showtoastmsg(String msg,
    {int type = 1, BuildContext? context, Function()? ontap}) {
  EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
  if (type == 1) {
    EasyLoading.showToast(msg);
  } else if (type == 2) {
    EasyLoading.showSuccess(msg);
  } else if (type == 3) {
    EasyLoading.showError(msg);
  }
  if (ontap != null || context != null) {
    Future.delayed(EasyLoading.instance.displayDuration).then((value) {
      if (ontap != null) {
        ontap();
      } else {
        Navigator.of(context!).pop();
      }
    });
  }
}




class VSpace extends StatelessWidget{
  final double height;


  VSpace(this.height);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(size: Size(0,height),);
  }
}

class HSpace extends StatelessWidget{
  final double width;


  HSpace(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(size: Size(width,0),);
  }
}
