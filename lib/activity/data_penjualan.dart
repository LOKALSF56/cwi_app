import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DataPenjualanPage extends StatefulWidget {
  const DataPenjualanPage({super.key});

  @override
  State<DataPenjualanPage> createState() => _DataPenjualanPageState();
}

class _DataPenjualanPageState extends State<DataPenjualanPage> {
  DateTime selectedDate = DateTime.now();
  int barangTerjual = 0;
  String palingLaris = "";
  List<Map<String, dynamic>> trafikMingguan = [];
  List<Map<String, dynamic>> listProdukTerjual = [];

  final String baseUrl = "http://192.168.1.10:3000";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    var url = Uri.parse("$baseUrl/api/penjualan?date=$dateStr");
    var res = await http.get(url);
    var data = jsonDecode(res.body);

    setState(() {
      barangTerjual = data["barangTerjual"];
      palingLaris = data["palingLaris"];
      trafikMingguan = List<Map<String, dynamic>>.from(data["trafikMingguan"]);
      listProdukTerjual = List<Map<String, dynamic>>.from(
        data["listProdukTerjual"],
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      loadData();
    }
  }

  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Laporan Penjualan',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Tanggal: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Barang Terjual: $barangTerjual',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Paling Laris: $palingLaris',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Trafik Mingguan:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table.fromTextArray(
              headers: ['Hari', 'Total Jual'],
              data: trafikMingguan
                  .map((item) => [item['hari'], item['total'].toString()])
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'List Produk Terjual:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table.fromTextArray(
              headers: ['Nama Produk', 'Jumlah Terjual'],
              data: listProdukTerjual
                  .map((item) => [item['nama'], item['jumlah'].toString()])
                  .toList(),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb3e5d6),
      appBar: AppBar(
        title: Text('Data Penjualan'),
        backgroundColor: Color(0xffb3e5d6),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE WITH DATE
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Data Penjualan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Icon(Icons.calendar_today, color: Colors.blue),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // CONTAINER FOR STATS AND CHART
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    // BARANG TERJUAL AND PALING LARIS SIDE BY SIDE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                barangTerjual.toString(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Barang Terjual",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                palingLaris,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Paling Laris",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // CHART
                    Container(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.blue,
                              spots: List.generate(
                                trafikMingguan.length,
                                (i) => FlSpot(
                                  i.toDouble(),
                                  trafikMingguan[i]['total'] * 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // LIST PRODUK TERJUAL
              Text(
                "List Produk Terjual",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...listProdukTerjual.map(
                (item) => Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['nama'], style: TextStyle(fontSize: 16)),
                      Text(
                        item['jumlah'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // DOWNLOAD PDF BUTTON
              Center(
                child: ElevatedButton(
                  onPressed: _downloadPDF,
                  child: Text('Download PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
