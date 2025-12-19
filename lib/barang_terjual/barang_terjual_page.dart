import 'package:cwi_app/widgets/barang_terjual_widget.dart';
import 'package:cwi_app/widgets/btn_widget.dart';
import 'package:flutter/material.dart';

class BarangTerjualPage extends StatelessWidget {
  const BarangTerjualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Barang Terjual"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const BarangTerjualWidget();
              },
            ),
          ),

          // ===== BUTTON AREA =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                BtnWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/tambah-barang-terjual');
                  },
                  width: 350,
                  height: 40,
                  text: "Tambah Barang",
                  bgcolor: Colors.blue,
                  textstyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  isUpercase: true,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
