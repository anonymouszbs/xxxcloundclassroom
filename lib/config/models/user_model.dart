import 'dart:convert';

class UserModel{
  UserModel({this.surname,this.pwd,this.workPermitNum});

  //姓名，工作证号码，部门
  String? surname;

  //密码
  String? pwd;

  //工作证号码

  String? workPermitNum;

  factory UserModel.fromjson(String str)=> UserModel.fromMap(json.decode(str));

  factory UserModel.fromMap(Map<dynamic,dynamic>json)=>UserModel(
    surname: json['surname'],
    pwd: json['pwd'],
    workPermitNum: json['workPermitNum']
  );
  
  Map<String,dynamic> toMap() =>{
    "surname" :surname,
    "pwd":pwd,
    "workPermitNum":workPermitNum
  };

}