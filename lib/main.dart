import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/dataconfig/global_config.dart';
import 'init/Application.dart';

void main(List<String> args) {

runZonedGuarded(
    () => init(),
    // ignore: avoid_print
    (err, stace) => print(FlutterErrorDetails(exception: err, stack: stace)),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        if (line.length > 800) {
          parent.print(zone, '字符串长度为 ${line.length}');
        } else {
          parent.print(zone, line);
        }
      },
    ),
  );
}
init() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await GloblConfig.init();
  runApp( Application());
}
