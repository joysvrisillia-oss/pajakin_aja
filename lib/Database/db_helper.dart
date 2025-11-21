import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/pajak_model.dart';

class DBHelper {
  static Database? _db;

  // ---------- Database init ----------
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
      version: 1,
      onCreate: (db, version) async {
        // users table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            role TEXT
          )
        ''');

        // pajak (riwayat)
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

        // tax_settings - store one row JSON (string)
        await db.execute('''
          CREATE TABLE tax_settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT
          )
        ''');

        // default admin account
        await db.insert("users", {
          "email": "admin@gmail.com",
          "password": "admin123",
          "role": "admin"
        });

        // default tax settings as JSON
        final defaultSettings = jsonEncode({
          "pph": [0.05, 0.15, 0.25, 0.30, 0.35],
          "umkm": 0.005,
          "pbb": 0.001,
          "ppn": 0.11,
          "labels": {
            "pph": "PPh Pribadi",
            "umkm": "Pajak Bisnis (UMKM)",
            "lainnya": "Pajak Lainnya (PBB & PPN)"
          }
        });

        await db.insert("tax_settings", {"data": defaultSettings});
      },
    );
  }

  // ---------- SESSION helpers ----------
  static Future<void> _saveLoggedInEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInEmail', email);
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInEmail');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInEmail');
  }

  // ---------- REGISTER (named params, so RegisterPage works) ----------
  static Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    final db = await database;
    await db.insert(
      "users",
      {"email": email, "password": password, "role": "user"},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // ---------- LOGIN (used by LoginPage) ----------
  // returns the user row as Map if success, else null
  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    final db = await database;
    final res = await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) {
      // save session
      await _saveLoggedInEmail(email);
      return res.first;
    }
    return null;
  }

  // ---------- PAJAK (riwayat) ----------
  // insertPajak expects PajakModel
  static Future<int> insertPajak(PajakModel model) async {
    final db = await database;
    return await db.insert("pajak", model.toMap());
  }

  // getPajakByUser returns List<Map<String,dynamic>> to remain compatible
  // with existing UI that expects raw maps (or other parts that used it)
  static Future<List<Map<String, dynamic>>> getPajakByUser(
      String email) async {
    final db = await database;
    final res = await db.query(
      "pajak",
      where: "email = ?",
      whereArgs: [email],
      orderBy: "id DESC",
    );
    return res;
  }

  // convenience: return strongly typed List<PajakModel>
  static Future<List<PajakModel>> getRiwayatModelsByEmail(
      String email) async {
    final rows = await getPajakByUser(email);
    return rows.map((r) => PajakModel.fromMap(r)).toList();
  }

  static Future<int> deletePajak(int id) async {
    final db = await database;
    return await db.delete("pajak", where: "id = ?", whereArgs: [id]);
  }

  // delete all per user
  static Future<int> deleteAll(String email) async {
    final db = await database;
    return await db.delete("pajak", where: "email = ?", whereArgs: [email]);
  }

  // ---------- TAX SETTINGS (JSON single-row) ----------
  // get settings as Map (decoded JSON)
  static Future<Map<String, dynamic>> getTaxSettings() async {
    final db = await database;
    final rows = await db.query("tax_settings", limit: 1);
    if (rows.isEmpty) {
      // fallback default if somehow absent
      return {
        "pph": [0.05, 0.15, 0.25, 0.30, 0.35],
        "umkm": 0.005,
        "pbb": 0.001,
        "ppn": 0.11,
      };
    }
    final dataStr = rows.first['data'] as String;
    final decoded = jsonDecode(dataStr) as Map<String, dynamic>;
    return decoded;
  }

  // update whole settings (pass a Map)
  static Future<int> updateTaxSettings(Map<String, dynamic> newSettings) async {
    final db = await database;
    final jsonStr = jsonEncode(newSettings);

    // if table empty, insert; else update first row
    final rows = await db.query("tax_settings", limit: 1);
    if (rows.isEmpty) {
      return await db.insert("tax_settings", {"data": jsonStr});
    } else {
      final id = rows.first['id'] as int;
      return await db.update("tax_settings", {"data": jsonStr},
          where: "id = ?", whereArgs: [id]);
    }
  }
}
