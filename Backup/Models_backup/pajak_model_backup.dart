class PajakModel {
  final int? id; // ← tambahkan id di sini
  final String jenisPajak;
  final double nilai;
  final double pajak;
  final String waktu;

  PajakModel({
    this.id,
    required this.jenisPajak,
    required this.nilai,
    required this.pajak,
    required this.waktu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenisPajak': jenisPajak,
      'nilai': nilai,
      'pajak': pajak,
      'waktu': waktu,
    };
  }

  factory PajakModel.fromMap(Map<String, dynamic> map) {
    return PajakModel(
      id: map['id'], // ← ambil id dari database
      jenisPajak: map['jenisPajak'],
      nilai: (map['nilai'] as num).toDouble(),
      pajak: (map['pajak'] as num).toDouble(),
      waktu: map['waktu'],
    );
  }
}
