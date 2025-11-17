import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/pajak_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pajakin.db');

    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            role TEXT NOT NULL DEFAULT 'user'
          )
        ''');

        await db.execute('''
          INSERT INTO users(email, password, role)
          VALUES ('admin@pajak.com', 'admin', 'admin')
        ''');

        await db.execute('''
          CREATE TABLE pajak(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenisPajak TEXT,
            nilai REAL,
            pajak REAL,
            waktu TEXT,
            user_email TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE session(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            role TEXT
          )
        ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          try {
            await db.execute("ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user'");
          } catch (e) {}

          try {
            await db.execute("ALTER TABLE session ADD COLUMN role TEXT");
          } catch (e) {}
        }
      },
    );
    return _db!;
  }

  // REGISTER USER
  static Future<int> registerUser({
    required String email,
    required String password,
  }) async {
    final db = await getDatabase();
    return await db.insert('users', {
      'email': email,
      'password': password,
      'role': 'user',
    });
  }

  // LOGIN
  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    final db = await getDatabase();
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final user = result.first;

      // simpan session
      await db.delete('session');
      await db.insert('session', {
        'email': user['email'],
        'role': user['role'],
      });

      return user;
    }
    return null;
  }

  // GET SESSION USER
  static Future<Map<String, dynamic>?> getSession() async {
    final db = await getDatabase();
    final result = await db.query('session');
    if (result.isNotEmpty) return result.first;
    return null;
  }

  static Future<String?> getLoggedInUser() async {
    final session = await getSession();
    return session?['email'];
  }

  static Future<String?> getLoggedInRole() async {
    final session = await getSession();
    return session?['role'];
  }

  // LOGOUT
  static Future<void> logout() async {
    final db = await getDatabase();
    await db.delete('session');
  }

  // PAJAK CRUD
  static Future<int> insertPajak(PajakModel data) async {
    final db = await getDatabase();
    return await db.insert('pajak', data.toMap());
  }

  static Future<List<PajakModel>> getPajakByUser(String email) async {
    final db = await getDatabase();
    final result = await db.query(
      'pajak',
      where: 'user_email = ?',
      whereArgs: [email],
      orderBy: 'id DESC',
    );
    return result.map((e) => PajakModel.fromMap(e)).toList();
  }

  static Future<int> deletePajak(int id) async {
    final db = await getDatabase();
    return await db.delete('pajak', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll(String email) async {
    final db = await getDatabase();
    await db.delete('pajak', where: 'user_email = ?', whereArgs: [email]);
  }
}
