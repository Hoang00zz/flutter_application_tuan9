import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthController {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'auth.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng users với ràng buộc UNIQUE cho email
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // Hàm Đăng ký (Register)
  Future<bool> registerUser(String email, String password) async {
    final db = await database;
    try {
      await db.insert('users', {'email': email, 'password': password});
      return true; // Đăng ký thành công
    } catch (e) {
      return false; // Lỗi (Thường là do email đã tồn tại)
    }
  }

  // Hàm Đăng nhập (Sign in)
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    // Tìm trong database xem có dòng nào khớp cả email và password không
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty; // Nếu có kết quả tức là đăng nhập thành công
  }
}