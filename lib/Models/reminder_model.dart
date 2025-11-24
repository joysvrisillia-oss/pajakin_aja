class ReminderModel {
  int? id;
  String judul;
  String tanggal;
  int isDone; // 0 for false, 1 for true

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
}