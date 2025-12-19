import 'package:cwi_app/widgets/btn_widget.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== HEADER CARD =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hi,', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text(
                          'Staff Gudang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Admin',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'No. Karyawan',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const Text('1905040051', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== FORM CARD =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  _ProfileField(label: 'Nama', value: 'Staff Gudang'),
                  _ProfileField(label: 'No. Karyawan', value: '1905040051'),
                  _ProfileField(label: 'No. Telepon', value: '085456526564'),
                  _ProfileField(label: 'Username', value: 'staff_gudang123'),
                  _ProfileField(label: 'Email', value: 'staffgudang@gmail.com'),
                  _ProfileField(
                    label: 'Password',
                    value: '**************',
                    isPassword: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== BUTTONS =====
            BtnWidget(
              onTap: () {
                Navigator.pushNamed(context, '/edit-profil');
              },
              // icon: Icons.add,
              width: 350,
              height: 40,
              text: "Edit",
              bgcolor: Colors.blue,
              textstyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              isUpercase: true,
            ),
            const SizedBox(height: 12),
            BtnWidget(
              onTap: () {},
              // icon: Icons.add,
              width: 350,
              height: 40,
              text: "Logout",
              bgcolor: Colors.red,
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
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;

  const _ProfileField({
    required this.label,
    required this.value,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isPassword)
                const Icon(Icons.visibility_off, size: 18, color: Colors.grey),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
