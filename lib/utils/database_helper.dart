import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Thêm thư viện path để nối chuỗi đường dẫn

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._int();
  static Database? _database;

  DatabaseHelper._int();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Lấy đường dẫn lưu file database
    String path = join(await getDatabasesPath(), 'tasks.db');

    // Mở database, tạo mới nếu chưa tồn tại
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng tasks
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }
}