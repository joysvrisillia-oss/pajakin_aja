class TaxSetting {
  final int? id;
  final String jenisPajak;     // contoh: "PPh Pribadi"
  final double tarif1;         // untuk pajak progresif bisa diisi 0
  final double tarif2;         // untuk pajak progresif bisa diisi 0
  final double tarif3;         // untuk pajak progresif bisa diisi 0
  final double tarifUMKM;      // khusus UMKM
  final double tarifPPN;       // khusus jenis pajak lain
  final double tarifPBB;       // khusus jenis pajak lain

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
