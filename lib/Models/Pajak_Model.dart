class PajakModel {
  final String jenisPajak;
  final double nilai;
  final double pajak;
  final String waktu;

  PajakModel({
    required this.jenisPajak,
    required this.nilai,
    required this.pajak,
    required this.waktu,
  });

  Map<String, dynamic> toMap() {
    return {
      'jenisPajak': jenisPajak,
      'nilai': nilai,
      'pajak': pajak,
      'waktu': waktu,
    };
  }

  factory PajakModel.fromMap(Map<String, dynamic> map) {
    return PajakModel(
      jenisPajak: map['jenisPajak'],
      nilai: map['nilai'],
      pajak: map['pajak'],
      waktu: map['waktu'],
    );
  }
}
