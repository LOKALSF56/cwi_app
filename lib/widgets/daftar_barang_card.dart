import 'package:flutter/material.dart';

class DaftarBarangCard extends StatelessWidget {
  final String namaProduk;
  final String tanggalMasuk;
  final int qty;
  final String unit;

  const DaftarBarangCard({
    super.key,
    required this.namaProduk,
    required this.tanggalMasuk,
    required this.qty,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO PRODUK
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text("Photo", style: TextStyle(color: Colors.black54)),
          ),

          const SizedBox(width: 12),

          // INFORMASI PRODUK
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaProduk,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                const Text(
                  "Tanggal Masuk",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  tanggalMasuk,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text("$qty"),

                    const SizedBox(width: 20),

                    const Text("Unit", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text(unit),
                  ],
                ),
              ],
            ),
          ),

          // BUTTON EDIT
          SizedBox(
            height: 35,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/edit-daftar-barang');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade100,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Edit", style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
