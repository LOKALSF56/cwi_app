import 'package:flutter/material.dart';

class TambahBarangTerjualPage extends StatefulWidget {
  const TambahBarangTerjualPage({super.key});

  @override
  State<TambahBarangTerjualPage> createState() => _TambahBarangTerjualPageState();
}

class _TambahBarangTerjualPageState extends State<TambahBarangTerjualPage> {
  String? selectedUnit;
  TextEditingController tglController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Tambah Barang Terjual"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ===========================
                // PHOTO UPLOAD MODERN UI
                // ===========================
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey.shade600),
                          const SizedBox(height: 6),
                          Text(
                            "Upload Photo",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ===========================
                // INPUT FIELDS
                // ===========================
                _label("Jenis Barang"),
                _modernInput("Jenis Barang"),

                const SizedBox(height: 20),

                _label("Qty"),
                _modernInput("Qty", keyboard: TextInputType.number),

                const SizedBox(height: 20),

                _label("Unit"),
                _modernDropdown(),

                const SizedBox(height: 20),

                _label("Tanggal Masuk"),
                _datePicker(),

                const SizedBox(height: 20),

                _label("Deskripsi"),
                _descriptionBox(),

                const SizedBox(height: 35),

                // ===========================
                // SAVE BUTTON
                // ===========================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================
  // LABEL
  // ===========================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  // ===========================
  // MODERN TEXT INPUT
  // ===========================
  Widget _modernInput(String hint,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // ===========================
  // DROPDOWN UNIT
  // ===========================
  Widget _modernDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUnit,
          hint: const Text("Pilih Unit"),
          items: const [
            DropdownMenuItem(value: "Pcs", child: Text("Pcs")),
            DropdownMenuItem(value: "Kg", child: Text("Kg")),
            DropdownMenuItem(value: "Dus", child: Text("Dus")),
          ],
          onChanged: (value) {
            setState(() {
              selectedUnit = value;
            });
          },
        ),
      ),
    );
  }

  // ===========================
  // DATE PICKER
  // ===========================
  Widget _datePicker() {
    return TextField(
      controller: tglController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Pilih tanggal...",
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              tglController.text =
                  "${picked.day}-${picked.month}-${picked.year}";
            }
          },
        ),
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // ===========================
  // DESCRIPTION BOX
  // ===========================
  Widget _descriptionBox() {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
