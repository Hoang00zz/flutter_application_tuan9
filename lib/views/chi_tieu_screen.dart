import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Dùng để format tiền tệ (VND)
import '../models/chi_tieu.dart';
import '../controllers/chi_tieu_controller.dart';

class ChiTieuScreen extends StatefulWidget {
  const ChiTieuScreen({super.key});

  @override
  State<ChiTieuScreen> createState() => _ChiTieuScreenState();
}

class _ChiTieuScreenState extends State<ChiTieuScreen> {
  final ChiTieuController _controller = ChiTieuController();
  List<ChiTieu> _danhSachChiTieu = [];

  // Hàm định dạng tiền tệ (vd: 100000 -> 100,000 đ)
  final currencyFormat = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _controller.fetchChiTieu();
    setState(() {
      _danhSachChiTieu = data;
    });
  }

  double _tinhTongChiTieu() {
    double tong = 0;
    for (var ct in _danhSachChiTieu) {
      tong += ct.soTien;
    }
    return tong;
  }

  void _showChiTieuDialog({ChiTieu? chiTieu}) {
    final noiDungController = TextEditingController(text: chiTieu?.noiDung ?? '');
    final soTienController = TextEditingController(
        text: chiTieu != null ? chiTieu.soTien.toInt().toString() : '');
    final ghiChuController = TextEditingController(text: chiTieu?.ghiChu ?? '');

    bool isUpdate = chiTieu != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isUpdate ? 'Cập nhật Chi Tiêu' : 'Thêm Chi Tiêu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noiDungController,
                decoration: const InputDecoration(labelText: 'Nội dung chi tiêu (vd: Ăn sáng)'),
              ),
              TextField(
                controller: soTienController,
                decoration: const InputDecoration(labelText: 'Số tiền (VND)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ghiChuController,
                decoration: const InputDecoration(labelText: 'Ghi chú thêm'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (noiDungController.text.isNotEmpty && soTienController.text.isNotEmpty) {
                double soTien = double.tryParse(soTienController.text) ?? 0;
                
                ChiTieu ct = ChiTieu(
                  id: chiTieu?.id,
                  noiDung: noiDungController.text,
                  soTien: soTien,
                  ghiChu: ghiChuController.text,
                );

                if (isUpdate) {
                  await _controller.updateChiTieu(ct);
                } else {
                  await _controller.insertChiTieu(ct);
                }
                
                if (mounted) Navigator.pop(context);
                _loadData();
              }
            },
            child: Text(isUpdate ? 'Cập nhật' : 'Lưu lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi Tiêu'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Thẻ hiển thị tổng tiền
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.teal.shade50,
            child: Column(
              children: [
                const Text('Tổng chi tiêu:', style: TextStyle(fontSize: 16, color: Colors.teal)),
                Text(
                  '${currencyFormat.format(_tinhTongChiTieu())} đ',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          
          // Danh sách chi tiêu
          Expanded(
            child: _danhSachChiTieu.isEmpty
                ? const Center(child: Text('Chưa có khoản chi tiêu nào.'))
                : ListView.builder(
                    itemCount: _danhSachChiTieu.length,
                    itemBuilder: (context, index) {
                      final ct = _danhSachChiTieu[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.attach_money, color: Colors.white),
                          ),
                          title: Text(ct.noiDung, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Ghi chú: ${ct.ghiChu}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${currencyFormat.format(ct.soTien)} đ',
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: () async {
                                  await _controller.deleteChiTieu(ct.id!);
                                  _loadData();
                                },
                              )
                            ],
                          ),
                          onTap: () => _showChiTieuDialog(chiTieu: ct),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChiTieuDialog(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}