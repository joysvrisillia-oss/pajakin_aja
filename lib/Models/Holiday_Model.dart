class Holiday {
  final String date;
  final String name;

  Holiday({
    required this.date,
    required this.name,
  });

  /// Factory constructor untuk membuat objek Holiday dari Map (JSON)
  /// PENTING: Kunci di sini ('date', 'name') harus sesuai dengan yang di-Map
  /// di dalam Api_Holiday.service.dart
  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'] as String,
      name: json['name'] as String,
    );
  }
}