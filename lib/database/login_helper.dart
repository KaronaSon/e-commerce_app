import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginDatabaseHelper {
  static final LoginDatabaseHelper instance = LoginDatabaseHelper._init();
  static Database? _database;

  LoginDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_registration.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL 
    )
    ''';

    await db.execute(userTable);
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  static Future<Map<String, dynamic>> getUserDetails(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.first;
  }
}
