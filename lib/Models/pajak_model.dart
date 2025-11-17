class PajakModel {
  final int? id;
  final String jenisPajak;
  final double nilai;
  final double pajak;
  final String waktu;
  final String userEmail;

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
      'id': id,
      'jenisPajak': jenisPajak,
      'nilai': nilai,
      'pajak': pajak,
      'waktu': waktu,
      'user_email': userEmail,
    };
  }

  factory PajakModel.fromMap(Map<String, dynamic> map) {
    return PajakModel(
      id: map['id'],
      jenisPajak: map['jenisPajak'],
      nilai: (map['nilai'] as num).toDouble(),
      pajak: (map['pajak'] as num).toDouble(),
      waktu: map['waktu'],
      userEmail: map['user_email'] ?? "",
    );
  }
}
