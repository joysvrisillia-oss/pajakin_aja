class ReminderModel {
  int? id;
  String judul;
  String tanggal;
  int isDone;

  ReminderModel({
    this.id,
    required this.judul,
    required this.tanggal,
    this.isDone = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "judul": judul,
      "tanggal": tanggal,
      "isDone": isDone,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map["id"],
      judul: map["judul"],
      tanggal: map["tanggal"],
      isDone: map["isDone"] ?? 0,
    );
  }
}
