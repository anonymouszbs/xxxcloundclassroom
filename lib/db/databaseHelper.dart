
import 'package:sqflite/sqflite.dart';
import 'package:xxxcloundclassroom/config/models/readbook_model.dart';
import 'package:xxxcloundclassroom/config/models/user_model.dart';

class DatabaseHelper {
  static const DB_PATH = "xxxykt.db";

  static const TABLE_USER = "ykt_user";

  static const TABLE_READBOOK_TAKEDOWN = "YKT_READBOOK_TAKE_DOWN";
  
  static const _SQL_CREATE_USER = '''
  CREATE TABLE "YKT_USER"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "surname" TEXT NOT NULL,
    "pwd" TEXT NOT NULL,
    "workPermitNum" integer NOT NULL
  )
''';
  static const _SQL_CREATE_READBOOK_TAKEDOWN = '''
  CREATE TABLE "YKT_READBOOK_TAKE_DOWN"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "surname" TEXT NOT NULL,
    "workPermitNum" integer NOT NULL,
    "bookname" TEXT NOT NULL,
    "bookindex" INTEGER NOT NULL,
    "bookchapter" INTEGER NOT NULL,
    "bookcontent" TEXT NOT NULL,
    "takedown" TEXT NOT NULL
  )
''';
  static DatabaseHelper? _instance;
  Database? _database;

  static _getInstance(){
    _instance ??= DatabaseHelper._internal();
    return _instance;
  }

  factory DatabaseHelper()=>_getInstance();

  DatabaseHelper._internal(){
    withDB().then((value) => print("${value.path},${value.isOpen}"));
  }

  Future<Database> withDB()async{
    if(_database!=null){
      return Future.value(_database);
    }
    return await openDatabase(DB_PATH,version: 3,onCreate: (Database database,int version)async{
     await _executeMultiSQL(database,_SQL_CREATE_USER);
     await _executeMultiSQL(database,_SQL_CREATE_READBOOK_TAKEDOWN);
    });

  }

  Future<int> _executeMultiSQL(Database db,String sql)async{
    var list = sql.split(";");
    for(var each in list){
      if(each.trim().isNotEmpty){
        await db.execute(each);
      }

    }
    return Future.value(0);
  }

  //用户登录后保存到本地
  Future<int> insertUserModel(UserModel usermodel) async {
    return await withDB().then((db){
      return db.transaction((txn){
        return txn.insert('ykt_user', usermodel.toMap());
        //return db.insert('ykt_user', usermodel.toMap());
      });
    });
  }

  Future<List<Map<String, Object?>>?> queryUser(){
    return withDB().then((db) => db.query(TABLE_USER,where: '1').then((value) {
      if(value.isEmpty){return null;}
      return value;
    }));
  }
  ///插入阅读笔记
  Future<int> insertReadBookTakeDownModel(ReadBookTakeDownModel readBookTakeDownModel)async{
    return await withDB().then((db){
      return db.transaction((txn){
        return txn.insert('YKT_READBOOK_TAKE_DOWN', readBookTakeDownModel.toMap());
      });
    });
  }

  ///查询阅读笔记
   Future<List<Map<String, Object?>>?> queryReadBookTakeDown(){
    return withDB().then((db) => db.query(TABLE_READBOOK_TAKEDOWN,where: '1').then((value) {
      if(value.isEmpty){return null;}
      return value;
    }));
  }

}
