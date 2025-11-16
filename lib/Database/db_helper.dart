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
      version: 1,
      onCreate: (db, version) async {
        // TABEL PAJAK
        await db.execute('''
          CREATE TABLE pajak(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenisPajak TEXT,
            nilai REAL,
            pajak REAL,
            waktu TEXT
          )
        ''');

        // TABEL USERS (SESUAI PERMINTAAN)
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  // ------------------ PAJAK ------------------ //

  static Future<int> insertPajak(PajakModel data) async {
    final db = await getDatabase();
    return await db.insert('pajak', data.toMap());
  }

  static Future<List<PajakModel>> getAllPajak() async {
    final db = await getDatabase();
    final result = await db.query('pajak', orderBy: 'id DESC');
    return result.map((e) => PajakModel.fromMap(e)).toList();
  }

  static Future<int> deletePajak(int id) async {
    final db = await getDatabase();
    return await db.delete('pajak', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await getDatabase();
    await db.delete('pajak');
  }

  // ------------------ AUTH ------------------ //

  // REGISTER
  static Future<int> registerUser({
    required String email,
    required String password,
  }) async {
    final db = await getDatabase();

    return await db.insert('users', {
      'email': email,
      'password': password,
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

    if (result.isNotEmpty) return result.first;
    return null;
  }
}
