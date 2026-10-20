import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task; // Nhận dữ liệu công việc được truyền từ màn hình chính sang

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskController _taskController = TaskController();
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái checkbox bằng với trạng thái hiện tại của công việc
    _isCompleted = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.task.title, style: const TextStyle(fontSize: 16)),
            
            const SizedBox(height: 24),
            
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.task.description, style: const TextStyle(fontSize: 16)),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                const Text('Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Checkbox(
                  value: _isCompleted,
                  onChanged: (bool? value) async {
                    if (value != null) {
                      setState(() {
                        _isCompleted = value; // Cập nhật giao diện Checkbox ngay lập tức
                      });
                      
                      // Cập nhật trạng thái xuống Database SQLite
                      Task updatedTask = Task(
                        id: widget.task.id,
                        title: widget.task.title,
                        description: widget.task.description,
                        isCompleted: value,
                      );
                      await _taskController.updateTask(updatedTask);
                      
                      // Tự động quay về màn hình trước và truyền tín hiệu 'true' để báo load lại list
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}