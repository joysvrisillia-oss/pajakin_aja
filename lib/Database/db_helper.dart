import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/pajak_model.dart';

class DBHelper {
  static Database? _db;

  // Dapatkan database, inisialisasi kalau belum ada
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pajakin.db');

    _db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertDefaultAdmin(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Tambahkan kolom baru kalau belum ada
          try {
            await db.execute(
                "ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user'");
          } catch (e) {}

          // Pastikan tabel session ada
          await db.execute('''
            CREATE TABLE IF NOT EXISTS session(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              email TEXT,
              role TEXT
            )
          ''');
        }
      },
    );

    return _db!;
  }

  // Buat semua tabel
  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS pajak(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jenisPajak TEXT,
        nilai REAL,
        pajak REAL,
        waktu TEXT,
        user_email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS session(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        role TEXT
      )
    ''');
  }

  // Insert admin default
  static Future<void> _insertDefaultAdmin(Database db) async {
    final result = await db.query('users', where: 'email = ?', whereArgs: ['admin@pajak.com']);
    if (result.isEmpty) {
      await db.insert('users', {
        'email': 'admin@pajak.com',
        'password': 'admin',
        'role': 'admin',
      });
    }
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
