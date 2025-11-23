import 'package:flutter/material.dart';
import '../Services/Panduan_Service.dart';
import '../Models/Panduan_Model.dart';

class AdminEditPanduanPage extends StatefulWidget {
  final bool isEdit;
  final PanduanModel? panduan;

  const AdminEditPanduanPage({
    super.key,
    required this.isEdit,
    this.panduan,
  });

  @override
  State<AdminEditPanduanPage> createState() => _AdminEditPanduanPageState();
}

class _AdminEditPanduanPageState extends State<AdminEditPanduanPage> {
  final _formKey = GlobalKey<FormState>();
  final PanduanService _service = PanduanService();

  late TextEditingController titleC;
  late TextEditingController descC;
  late TextEditingController contentC;

  @override
  void initState() {
    super.initState();
    titleC = TextEditingController(text: widget.isEdit ? widget.panduan?.title : "");
    descC = TextEditingController(text: widget.isEdit ? widget.panduan?.description : "");
    contentC = TextEditingController(text: widget.isEdit ? widget.panduan?.content : "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Panduan" : "Tambah Panduan"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(labelText: "Judul"),
                validator: (v) => v!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: descC,
                decoration: const InputDecoration(labelText: "Deskripsi Singkat"),
                validator: (v) => v!.isEmpty ? "Tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: contentC,
                decoration: const InputDecoration(labelText: "Konten Lengkap"),
                maxLines: 10,
                validator: (v) => v!.isEmpty ? "Tidak boleh kosong" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (widget.isEdit) {
                    await _service.updatePanduan(
                      widget.panduan!.id,
                      titleC.text,
                      descC.text,
                      contentC.text,
                    );
                  } else {
                    await _service.createPanduan(
                      titleC.text,
                      descC.text,
                      contentC.text,
                    );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.isEdit
                            ? "Perubahan berhasil disimpan ke API."
                            : "Panduan baru berhasil ditambahkan.",
                      ),
                      backgroundColor: Colors.blue.shade800,
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.isEdit ? "Simpan Perubahan" : "Tambah Panduan",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Tinjau Konten"),
                      content: SingleChildScrollView(child: Text(contentC.text)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Tutup"),
                        )
                      ],
                    ),
                  );
                },
                child: Text(
                  "Tinjau Perubahan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
