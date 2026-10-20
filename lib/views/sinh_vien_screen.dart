import 'package:flutter/material.dart';
import '../models/sinh_vien.dart';
import '../controllers/sinh_vien_controller.dart';

class SinhVienScreen extends StatefulWidget {
  const SinhVienScreen({super.key});

  @override
  State<SinhVienScreen> createState() => _SinhVienScreenState();
}

class _SinhVienScreenState extends State<SinhVienScreen> {
  final SinhVienController _controller = SinhVienController();
  List<SinhVien> _sinhViens = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSinhViens();
  }

  Future<void> _loadSinhViens([String? keyword]) async {
    final data = await _controller.fetchSinhViens(keyword);
    setState(() {
      _sinhViens = data;
    });
  }

  // DIALOG THÊM SINH VIÊN
  void _showAddDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Sinh Viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên Sinh Viên')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                await _controller.insertSinhVien(SinhVien(name: nameController.text, email: emailController.text));
                if (mounted) Navigator.pop(context);
                _loadSinhViens();
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  // DIALOG CẬP NHẬT SINH VIÊN
  void _showUpdateDialog(SinhVien sv) {
    final nameController = TextEditingController(text: sv.name);
    final emailController = TextEditingController(text: sv.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin chi tiết của sinh viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dữ liệu: ${sv.id} ${sv.name}', style: const TextStyle(color: Colors.grey)),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên Sinh Viên')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                await _controller.updateSinhVien(SinhVien(id: sv.id, name: nameController.text, email: emailController.text));
                if (mounted) Navigator.pop(context);
                _loadSinhViens();
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Sinh Viên')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sinh viên...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadSinhViens(); // Tải lại toàn bộ danh sách khi xóa tìm kiếm
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onChanged: (value) => _loadSinhViens(value), // Tìm kiếm realtime khi gõ
            ),
            const SizedBox(height: 16),
            
            // Danh sách sinh viên
            Expanded(
              child: ListView.builder(
                itemCount: _sinhViens.length,
                itemBuilder: (context, index) {
                  final sv = _sinhViens[index];
                  return Card(
                    color: Colors.grey.shade200,
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(sv.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      subtitle: Text(sv.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _controller.deleteSinhVien(sv.id!);
                          _loadSinhViens();
                        },
                      ),
                      onTap: () => _showUpdateDialog(sv), // Bấm vào để mở bảng Cập nhật
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Nút (+) Thêm Sinh Viên góc dưới
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.purple.shade100,
        child: const Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}