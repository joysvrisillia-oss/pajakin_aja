import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/pajak_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "pajakin_app.db");

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // USERS
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            role TEXT,
            isLoggedIn INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE pajak(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenisPajak TEXT,
            nilai REAL,
            pajak REAL,
            waktu TEXT,
            email TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE tax_settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            deskripsi TEXT,
            tanggal TEXT,
            jam TEXT,
            isDone INTEGER DEFAULT 0
          )
        ''');

        await db.insert("users", {
          "email": "admin@gmail.com",
          "password": "admin123",
          "role": "admin",
          "isLoggedIn": 0
        });

        final defaultSettings = jsonEncode({
          "pph": [0.05, 0.15, 0.25, 0.30, 0.35],
          "umkm": 0.005,
          "pbb": 0.001,
          "ppn": 0.11,
        });

        await db.insert("tax_settings", {"data": defaultSettings});
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE reminders(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              judul TEXT,
              deskripsi TEXT,
              tanggal TEXT,
              jam TEXT,
              isDone INTEGER DEFAULT 0
            )
          ''');
        }
      },
    );
  }

  static Future<Map<String, dynamic>?> loginUser(String email,
      String password) async {
    final db = await database;

    final res = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) {
      await db.update("users", {"isLoggedIn": 0});
      await db.update(
        "users",
        {"isLoggedIn": 1},
        where: "email = ?",
        whereArgs: [email],
      );
      return res.first;
    }
    return null;
  }

  static Future<void> logout() async {
    final db = await database;
    await db.update("users", {"isLoggedIn": 0});
  }

  static Future<String?> getLoggedInUser() async {
    final db = await database;
    final res = await db.query("users", where: "isLoggedIn = 1", limit: 1);
    if (res.isNotEmpty) return res.first["email"] as String;
    return null;
  }

  static Future<String?> getLoggedInUserRole() async {
    final db = await database;
    final res = await db.query(
      "users",
      columns: ["role"],
      where: "isLoggedIn = 1",
      limit: 1,
    );
    if (res.isNotEmpty) return res.first["role"] as String;
    return null;
  }

  static Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    final db = await database;
    await db.insert(
      "users",
      {
        "email": email,
        "password": password,
        "role": "user",
        "isLoggedIn": 0
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<int> insertPajak(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("pajak", data);
  }

  /*
  static Future<int> insertPajak(PajakModel model) async {
    final db = await database;
    return await db.insert("pajak", model.toMap());
  }
  */

  static Future<List<Map<String, dynamic>>> getPajakByUser(String email) async {
    final db = await database;
    return await db.query(
      "pajak",
      where: "email = ?",
      whereArgs: [email],
      orderBy: "id DESC",
    );
  }

  static Future<List<PajakModel>> getRiwayatModelsByEmail(String email) async {
    final rows = await getPajakByUser(email);
    return rows.map((r) => PajakModel.fromMap(r)).toList();
  }

  static Future<int> deletePajak(int id) async {
    final db = await database;
    return await db.delete("pajak", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteAll(String email) async {
    final db = await database;
    return await db.delete("pajak", where: "email = ?", whereArgs: [email]);
  }


  static Future<Map<String, dynamic>> getTaxSettings() async {
    final db = await database;
    final rows = await db.query("tax_settings", limit: 1);

    if (rows.isEmpty) {
      return {
        "pph": [0.05, 0.15, 0.25, 0.30, 0.35],
        "umkm": 0.005,
        "pbb": 0.001,
        "ppn": 0.11,
      };
    }
    return jsonDecode(rows.first['data'] as String);
  }

  static Future<int> updateTaxSettings(Map<String, dynamic> newSettings) async {
    final db = await database;
    final jsonStr = jsonEncode(newSettings);

    final rows = await db.query("tax_settings", limit: 1);
    if (rows.isEmpty) {
      return await db.insert("tax_settings", {"data": jsonStr});
    } else {
      final id = rows.first['id'] as int;
      return await db.update(
        "tax_settings",
        {"data": jsonStr},
        where: "id = ?",
        whereArgs: [id],
      );
    }
  }

  static Future<int> insertReminder(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("reminders", data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await database;
    return await db.query("reminders", orderBy: "id DESC");
  }

  static Future<int> updateReminder(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      "reminders",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      "reminders",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}