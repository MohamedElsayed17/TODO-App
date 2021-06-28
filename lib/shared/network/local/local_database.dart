import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/shared/network/local/database_constants.dart';

class DBLocalHelper {
  static const String DATABASE_NAME = 'TODO.db';
  static const int VERSION = 1;
  static const String TABLE_NAME = 'todo';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_TITLE = 'title';
  static const String COLUMN_TIME = 'time';
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_STATUS = 'status';

  DBLocalHelper._privateConstructor();
  static final DBLocalHelper getInstance = DBLocalHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();
    return _database;
  }

  Future<Database> _createDatabase() async {
    String path = join(await getDatabasesPath(), DATABASE_NAME);
    // await deleteDatabase(path);
    // bool ex = await databaseExists(path);
    // if (ex)
    //   print('database exsists');
    // else
    //   print('database is not exsist');

    return await openDatabase(
      path,
      version: VERSION,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE ${DatabaseConstants.TABLE_NAME}(
              ${DatabaseConstants.COLUMN_ID} INTEGER PRIMARY KEY,
              ${DatabaseConstants.COLUMN_TITLE} TEXT,
              ${DatabaseConstants.COLUMN_TIME} Text,
              ${DatabaseConstants.COLUMN_DATE} Text,
              ${DatabaseConstants.COLUMN_STATUS} TEXT
              )''').then((value) {
          print('database created');
        }).catchError((onError) {
          print('Error on creating database');
        });
      },
      onOpen: (database) {
        print('database opend');
      },
    );
  }

  Future<int> insert(Todo todo) async {
    Database? db = await getInstance.database;
    var res = await db!.insert(DatabaseConstants.TABLE_NAME, todo.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database? db = await getInstance.database;
    var res = await db!.query(DatabaseConstants.TABLE_NAME,
        orderBy: "${DatabaseConstants.COLUMN_ID} DESC");
    return res;
  }

  Future<List<Map<String, dynamic>>> getTasks({required String status}) async {
    Database? db = await getInstance.database;
    var res = await db!.query(DatabaseConstants.TABLE_NAME,
        orderBy: "${DatabaseConstants.COLUMN_ID} DESC",
        where: '${DatabaseConstants.COLUMN_STATUS} = ?',
        whereArgs: [status]);
    return res;
  }

  Future<int> delete(int id) async {
    Database? db = await getInstance.database;
    return await db!.delete(DatabaseConstants.TABLE_NAME,
        where: '${DatabaseConstants.COLUMN_ID} = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    Database? db = await getInstance.database;
    return await db!.update(DatabaseConstants.TABLE_NAME, todo.toMap(),
        where: '${DatabaseConstants.COLUMN_ID} = ?', whereArgs: [todo.id]);
  }

  clearTable() async {
    Database? db = await getInstance.database;
    return await db!.rawQuery("DELETE FROM $DatabaseConstants.TABLE_NAME");
  }
}
