import 'package:flutter/material.dart';

class KelolaPajakSetting extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>) onSave;

  const KelolaPajakSetting({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<KelolaPajakSetting> createState() => _KelolaPajakSettingState();
}

class _KelolaPajakSettingState extends State<KelolaPajakSetting> {
  late TextEditingController umkmC;
  late TextEditingController pbbC;
  late TextEditingController ppnC;

  late List<TextEditingController> pphControllers;

  @override
  void initState() {
    super.initState();

    umkmC = TextEditingController(text: widget.settings["umkm"].toString());
    pbbC = TextEditingController(text: widget.settings["pbb"].toString());
    ppnC = TextEditingController(text: widget.settings["ppn"].toString());

    pphControllers = (widget.settings["pph"] as List)
        .map((v) => TextEditingController(text: v.toString()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Setting Tarif Pajak"),
      insetPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PPh Pribadi (Tarif Progresif)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Column(
              children: List.generate(pphControllers.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: pphControllers[i],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Lapisan ${i + 1} (%)",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: umkmC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "UMKM (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: pbbC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "PBB (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: ppnC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "PPN (%)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            final newSettings = {
              "pph": pphControllers.map((c) => double.parse(c.text)).toList(),
              "umkm": double.parse(umkmC.text),
              "pbb": double.parse(pbbC.text),
              "ppn": double.parse(ppnC.text),
              "labels": widget.settings["labels"],
            };

            widget.onSave(newSettings);
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
