import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'data_penjualan.dart';
import 'login.dart';
import 'package:appwrite/appwrite.dart';
import '../services/appwrite_client.dart';

class MainPage extends StatefulWidget {
  final String userId;
  const MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String name = "Loading...";
  String role = "User";
  int barangMasuk = 0;
  int barangKeluar = 0;
  List<DateTime> weekDates = [];
  static const String databaseId = '6944300100059c12c035';
  static const String transaksiCollection = 'transaksi';
  static const String produkCollection = 'produk';
  List<double> chartMasuk = List.filled(7, 0);
  List<double> chartKeluar = List.filled(7, 0);

  @override
  void initState() {
    super.initState();
    _initWeekDates();
    loadUser();
    loadTodayData();
    loadWeeklyChart();
  }

  String getDayName(DateTime date) {
    const days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    return days[date.weekday % 7];
  }

  String getDateLabel(DateTime date) {
    return '${date.day}/${date.month}';
  }

  // GET USER
  Future<void> loadUser() async {
    try {
      final user = await AppwriteService.account.get();

      setState(() {
        name = user.name.isNotEmpty ? user.name : user.email;

        // 🔥 ROLE dari labels
        if (user.labels.contains('admin')) {
          role = 'admin';
        } else if (user.labels.contains('staff_gudang')) {
          role = 'staff_gudang';
        } else {
          role = 'user';
        }
      });
    } on AppwriteException catch (e) {
      debugPrint("Load user error: ${e.message}");
    }
  }

  Future<void> _logout() async {
    try {
      await AppwriteService.account.deleteSession(sessionId: 'current');
    } catch (_) {}

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
      );
    }
  }

  void _initWeekDates() {
    final now = DateTime.now();
    weekDates = List.generate(
      7,
      (i) => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i)),
    );
  }

  // GET TODAY BARANG MASUK & KELUAR
  Future<void> loadTodayData() async {
    try {
      final now = DateTime.now();
      final startToday = DateTime(now.year, now.month, now.day);
      final endToday = startToday.add(const Duration(days: 1));

      final res = await AppwriteService.databases.listDocuments(
        databaseId: databaseId,
        collectionId: transaksiCollection,
        queries: [
          Query.greaterThanEqual('tanggal', startToday.toIso8601String()),
          Query.lessThan('tanggal', endToday.toIso8601String()),
        ],
      );

      int masuk = 0;
      int keluar = 0;

      for (var doc in res.documents) {
        if (doc.data['jenis_transaksi'] == 'masuk') {
          masuk += (doc.data['jumlah'] ?? 0) as int;
        } else if (doc.data['jenis_transaksi'] == 'keluar') {
          keluar += (doc.data['jumlah'] ?? 0) as int;
        }
      }

      setState(() {
        barangMasuk = masuk;
        barangKeluar = keluar;
      });
    } on AppwriteException catch (e) {
      debugPrint('loadTodayData error: ${e.message}');
    }
  }

  // GET CHART WEEKLY
  Future<void> loadWeeklyChart() async {
    try {
      final now = DateTime.now();
      final startWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));

      final res = await AppwriteService.databases.listDocuments(
        databaseId: databaseId,
        collectionId: transaksiCollection,
        queries: [
          Query.greaterThanEqual('tanggal', startWeek.toIso8601String()),
        ],
      );

      List<double> masuk = List.filled(7, 0);
      List<double> keluar = List.filled(7, 0);

      for (var doc in res.documents) {
        final tanggal = DateTime.parse(doc.data['tanggal']);
        final index = tanggal.difference(startWeek).inDays;

        if (index >= 0 && index < 7) {
          if (doc.data['jenis_transaksi'] == 'masuk') {
            masuk[index] += (doc.data['jumlah'] ?? 0).toDouble();
          } else if (doc.data['jenis_transaksi'] == 'keluar') {
            keluar[index] += (doc.data['jumlah'] ?? 0).toDouble();
          }
        }
      }

      setState(() {
        chartMasuk = masuk;
        chartKeluar = keluar;
      });
    } on AppwriteException catch (e) {
      debugPrint('loadWeeklyChart error: ${e.message}');
    }
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
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: _logout,
                        ),
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
                    minX: 0,
                    maxX: 6,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      // 🔵 HARI (BAWAH)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 != 0) return const SizedBox.shrink();

                            final index = value.toInt();
                            if (index < 0 || index >= weekDates.length) {
                              return const SizedBox.shrink();
                            }

                            final date = weekDates[index];
                            final hari = [
                              'Min',
                              'Sen',
                              'Sel',
                              'Rab',
                              'Kam',
                              'Jum',
                              'Sab',
                            ][date.weekday % 7];

                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                hari,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),

                      // 🔴 TANGGAL (ATAS)
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 != 0) return const SizedBox.shrink();

                            final index = value.toInt();
                            if (index < 0 || index >= weekDates.length) {
                              return const SizedBox.shrink();
                            }

                            final date = weekDates[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        spots: List.generate(
                          7,
                          (i) => FlSpot(i.toDouble(), chartMasuk[i]),
                        ),
                      ),
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
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
