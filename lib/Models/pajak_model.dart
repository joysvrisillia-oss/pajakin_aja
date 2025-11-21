class PajakModel {
  int? id;
  String jenisPajak;
  double nilai;
  double pajak;
  String waktu;
  String userEmail;

  PajakModel({
    this.id,
    required this.jenisPajak,
    required this.nilai,
    required this.pajak,
    required this.waktu,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "jenisPajak": jenisPajak,
      "nilai": nilai,
      "pajak": pajak,
      "waktu": waktu,
      "email": userEmail,
    };
  }

  factory PajakModel.fromMap(Map<String, dynamic> map) {
    return PajakModel(
      id: map["id"],
      jenisPajak: map["jenisPajak"],
      nilai: map["nilai"],
      pajak: map["pajak"],
      waktu: map["waktu"],
      userEmail: map["email"],
    );
  }
}
