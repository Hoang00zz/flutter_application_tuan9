import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chi_tieu.dart';

class ChiTieuController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quanlychitieu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chitieu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noidung TEXT,
            sotien REAL,
            ghichu TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertChiTieu(ChiTieu ct) async {
    final db = await database;
    await db.insert('chitieu', ct.toMap());
  }

  Future<void> updateChiTieu(ChiTieu ct) async {
    final db = await database;
    await db.update('chitieu', ct.toMap(), where: 'id=?', whereArgs: [ct.id]);
  }

  Future<void> deleteChiTieu(int id) async {
    final db = await database;
    await db.delete('chitieu', where: 'id=?', whereArgs: [id]);
  }

  Future<List<ChiTieu>> fetchChiTieu() async {
    final db = await database;
    final maps = await db.query('chitieu', orderBy: 'id DESC'); // Lấy mới nhất lên đầu
    return maps.map((obj) => ChiTieu.fromMap(obj)).toList();
  }
}