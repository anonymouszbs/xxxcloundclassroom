import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/home_bottom_navigatorbar.dart';
import 'package:xxxcloundclassroom/pages/home/controllers/pages/home_index.dart';

class NavHomePage extends StatefulWidget {
  const NavHomePage({Key? key}) : super(key: key);

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  @override
  Widget build(BuildContext context) {
    return  HomeBottmNavigatorBar();
  }
}