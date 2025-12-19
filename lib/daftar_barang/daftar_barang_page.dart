import 'package:cwi_app/widgets/btn_widget.dart';
import 'package:cwi_app/widgets/daftar_barang_card.dart';
import 'package:flutter/material.dart';

class DaftarBarang extends StatelessWidget {
  const DaftarBarang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Daftar Barang"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // LIST PRODUK
              Column(
                children: const [
                  DaftarBarangCard(
                    namaProduk: "Produk A",
                    tanggalMasuk: "12-November-2025",
                    qty: 250,
                    unit: "Pcs",
                  ),
                  DaftarBarangCard(
                    namaProduk: "Produk B",
                    tanggalMasuk: "13-November-2025",
                    qty: 120,
                    unit: "Kg",
                  ),
                  DaftarBarangCard(
                    namaProduk: "Produk C",
                    tanggalMasuk: "15-November-2025",
                    qty: 50,
                    unit: "Dus",
                  ),
                  DaftarBarangCard(
                    namaProduk: "Produk C",
                    tanggalMasuk: "15-November-2025",
                    qty: 50,
                    unit: "Dus",
                  ),
                ],
              ),
              // button bawah
              BtnWidget(
                onTap: () {
                  Navigator.pushNamed(context, '/tambah-barang');
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
              const SizedBox(height: 15),
              BtnWidget(
                onTap: () {},
                width: 350,
                height: 40,
                text: "Downlowad PDF",
                bgcolor: Colors.blue,
                textstyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                isUpercase: true,
              ),
              const SizedBox(height: 15),

              BtnWidget(
                onTap: () {},
                // icon: Icons.add,
                width: 350,
                height: 40,
                text: "Save",
                bgcolor: Colors.blue,
                textstyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                isUpercase: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
