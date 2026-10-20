class ChiTieu {
  final int? id;
  final String noiDung;
  final double soTien;
  final String ghiChu;

  ChiTieu({
    this.id,
    required this.noiDung,
    required this.soTien,
    required this.ghiChu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noidung': noiDung,
      'sotien': soTien,
      'ghichu': ghiChu,
    };
  }

  factory ChiTieu.fromMap(Map<String, dynamic> map) {
    return ChiTieu(
      id: map['id'],
      noiDung: map['noidung'],
      // Xử lý an toàn kiểu dữ liệu số tiền (int hoặc double từ SQLite)
      soTien: (map['sotien'] is int) ? (map['sotien'] as int).toDouble() : map['sotien'],
      ghiChu: map['ghichu'],
    );
  }
}