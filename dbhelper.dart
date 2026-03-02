import 'package:app/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'app.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // TODO TABLE
        await db.execute('''
        CREATE TABLE todo(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT
        )
        ''');

        // USER TABLE
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          email TEXT UNIQUE,
          password TEXT
        )
        ''');
      },
    );

    return _db!;
  }

  // REGISTER USER
  static Future<int> registerUser(UserModel user) async {
    final db = await getDatabase();
    return await db.insert('users', user.toMap());
  }

  // LOGIN USER
  static Future<UserModel?> loginUser(String email, String password) async {
    final db = await getDatabase();

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}
