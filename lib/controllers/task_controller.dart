import '../utils/database_helper.dart';
import '../models/task.dart';

class TaskController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Thêm công việc
  Future<void> insertTask(Task task) async {
    final db = await _dbHelper.database;
    await db.insert('tasks', task.toMap());
  }

  // Cập nhật công việc
  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update('tasks', task.toMap(), where: 'id=?', whereArgs: [task.id]);
  }

  // Xóa công việc
  Future<void> deleteTask(int id) async {
    final db = await _dbHelper.database;
    await db.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  // Tìm kiếm theo tiêu đề hoặc mô tả
  Future<List<Task>> searchTasks(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((obj) => Task.fromMap(obj)).toList();
  }

  // Lấy toàn bộ danh sách
  Future<List<Task>> fetchTasks() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((obj) => Task.fromMap(obj)).toList();
  }
}