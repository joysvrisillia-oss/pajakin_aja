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
        await db.execute('''
          CREATE TABLE pajak(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            jenisPajak TEXT,
            nilai REAL,
            pajak REAL,
            waktu TEXT
          )
        ''');
      },
    );
    return _db!;
  }

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
}
