import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_detail.dart'; // Đảm bảo bạn đã lưu file task_detail.dart của Bài 1 vào cùng thư mục views này

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [];
  final TaskController _taskController = TaskController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await _taskController.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty) return;
                      // Tạo Task mới
                      Task newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch, // Dùng timestamp làm ID để không bị trùng
                        title: titleController.text,
                        description: descriptionController.text,
                      );
                      _taskController.insertTask(newTask).then((_) {
                        _fetchTasks();
                        titleController.clear();
                        descriptionController.clear();
                      });
                    },
                    child: const Text('Add Task'),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Xóa Task cuối cùng
                      if (_tasks.isNotEmpty) {
                        Task lastTask = _tasks.last;
                        _taskController.deleteTask(lastTask.id).then((_) {
                          _fetchTasks();
                        });
                      }
                    },
                    child: const Text("Delete Task"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: task.isCompleted ? Colors.green[100] : Colors.white, // Chuyển màu xanh nếu hoàn thành
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          titleController.text = task.title;
                          descriptionController.text = task.description;
                        },
                      ),
                      onTap: () async {
                        // CHUYỂN SANG TRANG CHI TIẾT CỦA BÀI TẬP 1
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                        );
                        if (result == true) {
                          _fetchTasks(); // Load lại danh sách sau khi tick Completed
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}