import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqlDb {

  static Database? _db ; 
  
  Future<Database?> get db async {
      if (_db == null){
        _db  = await intialDb() ;
        return _db ;  
      }else {
        return _db ; 
      }
  }


intialDb() async {
  String databasepath = await getDatabasesPath() ; 
  String path = join(databasepath , 'homz.db') ;   
  Database mydb = await openDatabase(path , onCreate: _onCreate , version: 3  , onUpgrade:_onUpgrade ) ;  
  return mydb ; 
}

_onUpgrade(Database db , int oldversion , int newversion ) {


 print("onUpgrade =====================================") ; 
  
}

_onCreate(Database db , int version) async {

    // await db.execute('''
    //   CREATE TABLE "users" (
    //     "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    //     "username" TEXT NOT NULL UNIQUE,
    //     "password" TEXT NOT NULL
    //   )
    // ''');
await db.execute('''
  CREATE TABLE "apartment_favorite" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "apartmentId" INTEGER NOT NULL,
    FOREIGN KEY (apartmentId) REFERENCES apartment(id)  -- Assuming there's a recipes table
  )
''');

 print(" onCreate =====================================") ; 

}
  Future<int> createUser(String username, String password) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert('''
      INSERT INTO users (username, password) VALUES (?, ?)
    ''', [username, password]);
    return response;
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.rawQuery('''
      SELECT * FROM users WHERE username = ? AND password = ?
    ''', [username, password]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null; 
    }
  }
 Future<int> addFavorite(int apartmentId) async {
  Database? mydb = await db;

  List<Map<String, dynamic>> existingApartment = await mydb!.rawQuery('''
    SELECT * FROM apartment_favorite 
    WHERE apartmentId = ?
  ''', [apartmentId]);

  if (existingApartment.isEmpty) {
    int response = await mydb.rawInsert('''
      INSERT INTO apartment_favorite (apartmentId)
      VALUES (?)
    ''', [apartmentId]);
    return response;
  } else {
   
    return 0;
  }
}


 Future<List<Map<String, dynamic>>> getUserFavorites() async {
  Database? mydb = await db;

  List<Map<String, dynamic>> response = await mydb!.rawQuery('''
    SELECT apartment_favorite.* FROM apartment_favorite
  ''');

  return response;
}

Future<int> deleteFavorite(int apartmentId) async {
  Database? mydb = await db;
  int response = await mydb!.rawDelete('''
    DELETE FROM apartment_favorite 
    WHERE apartmentId = ?
  ''', [apartmentId]);

  return response;
}
readData(String sql) async {
  Database? mydb = await db ; 
  List<Map> response = await  mydb!.rawQuery(sql);
  return response ; 
}
insertData(String sql) async {
  Database? mydb = await db ; 
  int  response = await  mydb!.rawInsert(sql);
  return response ; 
}
updateData(String sql) async {
  Database? mydb = await db ; 
  int  response = await  mydb!.rawUpdate(sql);
  return response ; 
}
deleteData(String sql) async {
  Database? mydb = await db ; 
  int  response = await  mydb!.rawDelete(sql);
  return response ; 
}

}