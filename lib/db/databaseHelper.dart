
import 'package:sqflite/sqflite.dart';
import 'package:xxxcloundclassroom/config/models/user_model.dart';

class DatabaseHelper {
  static const DB_PATH = "xxxykt.db";

  static const TABLE_USER = "ykt_user";
  
  static const _SQL_CREATE_USER = '''
  CREATE TABLE "YKT_USER"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "surname" TEXT NOT NULL,
    "pwd" TEXT NOT NULL,
    "workPermitNum" integer NOT NULL
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

}
