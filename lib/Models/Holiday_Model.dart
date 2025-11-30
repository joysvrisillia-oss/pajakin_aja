class Holiday {
  final String date;
  final String name;

  Holiday({
    required this.date,
    required this.name,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'] as String,
      name: json['name'] as String,
    );
  }
}