import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sinh_vien.dart';

class SinhVienController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sinhvien.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sinhvien (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertSinhVien(SinhVien sv) async {
    final db = await database;
    await db.insert('sinhvien', sv.toMap());
  }

  Future<void> updateSinhVien(SinhVien sv) async {
    final db = await database;
    await db.update('sinhvien', sv.toMap(), where: 'id=?', whereArgs: [sv.id]);
  }

  Future<void> deleteSinhVien(int id) async {
    final db = await database;
    await db.delete('sinhvien', where: 'id=?', whereArgs: [id]);
  }

  Future<List<SinhVien>> fetchSinhViens([String? keyword]) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (keyword != null && keyword.isNotEmpty) {
      // Tìm kiếm theo tên gần đúng
      maps = await db.query('sinhvien', where: 'name LIKE ?', whereArgs: ['%$keyword%']);
    } else {
      maps = await db.query('sinhvien');
    }
    return maps.map((obj) => SinhVien.fromMap(obj)).toList();
  }
}