
import 'package:flutter/widgets.dart';

class KeepLivepage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final frame;
  const KeepLivepage({Key? key,this.frame}) : super(key: key);

  @override
  State<KeepLivepage> createState() => _KeepLivepageState();
}

class _KeepLivepageState extends State<KeepLivepage> with AutomaticKeepAliveClientMixin{
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return widget.frame;
  }
  
  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>  true;
}