import 'package:flutter/material.dart';
import '../Models/Panduan_Model.dart';
import '../Services/Panduan_Service.dart';

class PanduanPajakPage extends StatefulWidget {
  const PanduanPajakPage({super.key});

  @override
  State<PanduanPajakPage> createState() => _PanduanPajakPageState();
}

class _PanduanPajakPageState extends State<PanduanPajakPage> {
  final PanduanService _service = PanduanService();
  late Future<List<PanduanModel>> _futurePanduan;

  @override
  void initState() {
    super.initState();
    _futurePanduan = _service.getPanduan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panduan & Tips Pajak"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),

      body: FutureBuilder<List<PanduanModel>>(
        future: _futurePanduan,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(p.description),
                  const SizedBox(height: 10),

                  Text(
                    p.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const Divider(height: 30),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
