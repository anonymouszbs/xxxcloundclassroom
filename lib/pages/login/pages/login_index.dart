import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xxxcloundclassroom/pages/login/controller/login_c.dart';

class LoginIndexPage extends StatefulWidget {
  const LoginIndexPage({Key? key}) : super(key: key);

  @override
  State<LoginIndexPage> createState() => _LoginIndexPageState();
}

class _LoginIndexPageState extends State<LoginIndexPage> {
  @override
  Loginc get controller => Get.put(Loginc());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        centerTitle: true,
        leading: Container(),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.settings))],
        title: Container(
          padding: EdgeInsets.only(top: 0),
          height: 25.h,
          alignment: Alignment.center,
          child: const Text(
            "xxx云课堂",
            style: TextStyle(),
          ),
          
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.withBlue(100), Colors.blue.withBlue(120),Colors.blue.withBlue(140)],
          ),
        ),
        child: Center(
          child: Container(
            width: 500.w,
            padding: EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                  width: 0.6, color: Colors.white, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  '登录',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  
                  decoration: InputDecoration(

                    hoverColor: Colors.white,
                    labelText: '用户名',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '密码',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.taplogin();
                        },
                        child: Text('登录'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Colors.blue[500],
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text('注册'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          primary: Colors.deepPurple[400],
                          textStyle: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
