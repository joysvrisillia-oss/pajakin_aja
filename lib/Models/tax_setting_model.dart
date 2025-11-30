class TaxSetting {
  final int? id;
  final String jenisPajak;
  final double tarif1;
  final double tarif2;
  final double tarif3;
  final double tarifUMKM;
  final double tarifPPN;
  final double tarifPBB;

  TaxSetting({
    this.id,
    required this.jenisPajak,
    required this.tarif1,
    required this.tarif2,
    required this.tarif3,
    required this.tarifUMKM,
    required this.tarifPPN,
    required this.tarifPBB,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenisPajak': jenisPajak,
      'tarif1': tarif1,
      'tarif2': tarif2,
      'tarif3': tarif3,
      'tarifUMKM': tarifUMKM,
      'tarifPPN': tarifPPN,
      'tarifPBB': tarifPBB,
    };
  }

  factory TaxSetting.fromMap(Map<String, dynamic> map) {
    return TaxSetting(
      id: map['id'],
      jenisPajak: map['jenisPajak'],
      tarif1: map['tarif1'],
      tarif2: map['tarif2'],
      tarif3: map['tarif3'],
      tarifUMKM: map['tarifUMKM'],
      tarifPPN: map['tarifPPN'],
      tarifPBB: map['tarifPBB'],
    );
  }
}
