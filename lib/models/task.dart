class Task {
  int id;
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Chuyển Task thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Chuyển Map từ SQLite thành đối tượng Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}