
import 'dart:convert';

class ReadBookTakeDownModel {
  String? surname;
  String? workPermitNum;
  String? bookname;
  String? bookindex;
  String? bookchapter;
  String? takedown;
  String? bookcontent;

  ReadBookTakeDownModel({this.surname,this.workPermitNum,this.bookname,this.bookindex,this.takedown,this.bookcontent,this.bookchapter});

  factory ReadBookTakeDownModel.fromjson(String str)=> ReadBookTakeDownModel.fromMap(json.decode(str));

  factory ReadBookTakeDownModel.fromMap(Map<dynamic,dynamic>json)=>ReadBookTakeDownModel(
    surname: json['surname'],
    workPermitNum: json['workPermitNum'],
    bookname: json['bookname'],
    bookindex: json['bookindex'],
    takedown: json['takedown'],
    bookcontent: json['bookcontent'],
    bookchapter: json['bookchapter']
  );
  
  Map<String,dynamic> toMap() =>{
    "surname":surname,
    "workPermitNum":workPermitNum,
    "bookname":bookname,
    "bookindex":bookindex,
    "takedown":takedown,
    "bookcontent":bookcontent,
    "bookchapter":bookchapter
  };
}