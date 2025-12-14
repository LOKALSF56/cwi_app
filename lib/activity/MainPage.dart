import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'data_penjualan.dart';

class MainPage extends StatefulWidget {
  final int userId;
  const MainPage({required this.userId, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String name = "";
  String role = "";
  int barangMasuk = 0;
  int barangKeluar = 0;

  List<double> chartMasuk = List.filled(7, 0);
  List<double> chartKeluar = List.filled(7, 0);

  final String baseUrl = "http://192.168.1.10:3000";

  @override
  void initState() {
    super.initState();
    loadUser();
    loadTodayData();
    loadWeeklyChart();
  }

  // GET USER
  Future<void> loadUser() async {
    var url = Uri.parse("$baseUrl/user/${widget.userId}");
    var res = await http.get(url);
    var data = jsonDecode(res.body);

    setState(() {
      name = data["name"];
      role = data["role"];
    });
  }

  // GET TODAY BARANG MASUK & KELUAR
  Future<void> loadTodayData() async {
    var masuk = await http.get(Uri.parse("$baseUrl/barang-masuk-today"));
    var keluar = await http.get(Uri.parse("$baseUrl/barang-keluar-today"));

    setState(() {
      barangMasuk = jsonDecode(masuk.body)["total"];
      barangKeluar = jsonDecode(keluar.body)["total"];
    });
  }

  // GET CHART WEEKLY
  Future<void> loadWeeklyChart() async {
    var res = await http.get(Uri.parse("$baseUrl/chart-weekly"));
    List data = jsonDecode(res.body);

    List<double> masuk = List.filled(7, 0);
    List<double> keluar = List.filled(7, 0);

    for (int i = 0; i < data.length; i++) {
      masuk[i] = data[i]["masuk"] * 1.0;
      keluar[i] = data[i]["keluar"] * 1.0;
    }

    setState(() {
      chartMasuk = masuk;
      chartKeluar = keluar;
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3e5d6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER USER
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi,", style: TextStyle(fontSize: 18)),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 5),
                        Text(role),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // BARANG MASUK & KELUAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  statCard(barangMasuk, "Barang Masuk"),
                  statCard(barangKeluar, "Barang Terjual"),
                ],
              ),

              SizedBox(height: 20),

              // CHART
              Container(
                height: 250,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.blue,
                        spots: List.generate(
                          7,
                          (i) => FlSpot(i.toDouble(), chartMasuk[i]),
                        ),
                      ),
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.green,
                        spots: List.generate(
                          7,
                          (i) => FlSpot(i.toDouble(), chartKeluar[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              Text(
                "Menu Admin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: menuButtons(role),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(int jumlah, String label) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            jumlah.toString(),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // MENU DINAMIS
  List<Widget> menuButtons(String role) {
    List<Widget> admin = [
      menuItem(
        "assets/barang_masuk.png",
        "",
        onTap: () => _navigateToActivity("Barang Masuk"),
      ),
      menuItem(
        "assets/barang_terjual.png",
        "",
        onTap: () => _navigateToActivity("Barang Terjual"),
      ),
      menuItem(
        "assets/daftar_barang.png",
        "",
        onTap: () => _navigateToActivity("Daftar Barang"),
      ),
      menuItem(
        "assets/data_penjualan.png",
        "",
        onTap: () => _navigateToActivity("Data Penjualan"),
      ),
    ];

    List<Widget> user = [
      menuItem(
        "assets/daftar_barang.png",
        "",
        onTap: () => _navigateToActivity("Daftar Barang"),
      ),
      menuItem(
        "assets/data_penjualan.png",
        "",
        onTap: () => _navigateToActivity("Data Penjualan"),
      ),
    ];

    return (role == "admin" || role == "staff_gudang") ? admin : user;
  }

  void _navigateToActivity(String activity) {
    if (activity == "Data Penjualan") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataPenjualanPage()),
      );
    } else {
      // TODO: Implement navigation to other activities
      print("Navigate to $activity");
    }
  }

  Widget menuItem(String imagePath, String label, {VoidCallback? onTap}) {
    Widget content = Column(
      children: [
        Container(
          width: 60,
          height: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
    if (onTap != null) {
      content = GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
