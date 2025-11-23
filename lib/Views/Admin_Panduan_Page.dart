import 'package:flutter/material.dart';
import '../Services/Panduan_Service.dart';
import '../Models/Panduan_Model.dart';
import 'Admin_Edit_Panduan_Page.dart';
import '../Views/Panduan_Pajak.dart';

class AdminPanduanPage extends StatefulWidget {
  const AdminPanduanPage({super.key});

  @override
  State<AdminPanduanPage> createState() => _AdminPanduanPageState();
}

class _AdminPanduanPageState extends State<AdminPanduanPage> {
  final PanduanService _service = PanduanService();
  late Future<List<PanduanModel>> _futurePanduan;

  @override
  void initState() {
    super.initState();
    _futurePanduan = _service.getPanduan();
  }

  void refreshData() {
    setState(() {
      _futurePanduan = _service.getPanduan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panduan & Tips Pajak"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminEditPanduanPage(isEdit: false),
                ),
              ).then((_) => refreshData());
            },
          )
        ],
      ),

      body: FutureBuilder<List<PanduanModel>>(
        future: _futurePanduan,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PanduanPajakPage(),
                      ),
                    );
                  },

                  title: Text(p.title),
                  subtitle: Text(
                    p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminEditPanduanPage(
                                isEdit: true,
                                panduan: p,
                              ),
                            ),
                          ).then((_) => refreshData());
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _service.deletePanduan(p.id);
                          refreshData();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
