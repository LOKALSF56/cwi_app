const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Konfigurasi koneksi MySQL
const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'cwi_data'
};

const pool = mysql.createPool(dbConfig);

// Endpoint login
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email dan password diperlukan' });
    }

    const [rows] = await pool.execute('SELECT * FROM users WHERE email = ?', [email]);

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Email tidak terdaftar' });
    }

    const user = rows[0];
    
    // Verifikasi password (jika menggunakan bcrypt)
    // const passwordMatch = await bcrypt.compare(password, user.password);
    
    // Untuk testing, gunakan plain text comparison
    const passwordMatch = password === user.password;

    if (!passwordMatch) {
      return res.status(401).json({ message: 'Password salah' });
    }

    res.json({
      message: 'Login berhasil',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});


// Endpoint ambil data user by id
app.get('/user/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [results] = await pool.execute('SELECT * FROM users WHERE id = ?', [id]);
    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(results[0]);
  } catch (err) {
    res.status(500).send(err);
  }
});

// Endpoint ambil data user
app.get('/users', async (req, res) => {
  try {
    const [results] = await pool.execute('SELECT * FROM users');
    res.json(results);
  } catch (err) {
    res.status(500).send(err);
  }
});


// Endpoint tambah user
app.post('/users', async (req, res) => {
  const { name, email } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO users (name, email) VALUES (?, ?)', [name, email]);
    res.json({ id: result.insertId, name, email });
  } catch (err) {
    res.status(500).send(err);
  }
});

// Endpoint utama untuk mendapatkan data penjualan harian
app.get('/api/penjualan', async (req, res) => {
    // Ambil tanggal dari query parameter, default ke tanggal hari ini
    const selectedDate = req.query.date || new Date().toISOString().split('T')[0]; // Format YYYY-MM-DD
    
    try {
        // --- 1. BARANG TERJUAL HARI INI ---
        const [totalTerjualResult] = await pool.execute(
            `SELECT SUM(jumlah_terjual) AS total 
             FROM transaksi 
             WHERE tanggal_transaksi = ?`, 
            [selectedDate]
        );
        const barangTerjual = totalTerjualResult[0].total || 0;

        // --- 2. PALING LARIS HARI INI ---
        const [palingLarisResult] = await pool.execute(
            `SELECT p.nama_produk, SUM(t.jumlah_terjual) AS total_jual
             FROM transaksi t
             JOIN produk p ON t.id_produk = p.id_produk
             WHERE t.tanggal_transaksi = ?
             GROUP BY p.nama_produk
             ORDER BY total_jual DESC
             LIMIT 1`,
            [selectedDate]
        );
        const palingLaris = palingLarisResult.length > 0 ? palingLarisResult[0].nama_produk : 'N/A';
        
        // --- 3. TRAFIK PENJUALAN MINGGUAN (Chart) ---
        // Asumsi kita mencari 7 hari *sebelum* tanggal yang dipilih (termasuk hari itu)
        const dateObj = new Date(selectedDate);
        dateObj.setDate(dateObj.getDate() - 6);
        const startDate = dateObj.toISOString().split('T')[0];

        const [trafikMingguanResult] = await pool.execute(
            `SELECT 
                DATE_FORMAT(tanggal_transaksi, '%a') AS hari,
                SUM(jumlah_terjual) AS total_jual
             FROM transaksi
             WHERE tanggal_transaksi BETWEEN ? AND ?
             GROUP BY tanggal_transaksi
             ORDER BY tanggal_transaksi ASC`,
            [startDate, selectedDate]
        );
        
        // Data harus lengkap 7 hari. Jika ada hari yang tidak ada transaksi, tambahkan 0.
        // Untuk penyederhanaan, kita langsung gunakan hasil query ini.
        const trafikMingguan = trafikMingguanResult.map(row => ({
            hari: row.hari,
            total: row.total_jual
        }));

        // --- 4. LIST PRODUK TERJUAL HARI INI ---
        const [listProdukResult] = await pool.execute(
            `SELECT p.nama_produk, SUM(t.jumlah_terjual) AS total_terjual
             FROM transaksi t
             JOIN produk p ON t.id_produk = p.id_produk
             WHERE t.tanggal_transaksi = ?
             GROUP BY p.nama_produk
             ORDER BY total_terjual DESC`,
            [selectedDate]
        );

        res.json({
            tanggal: selectedDate,
            barangTerjual: barangTerjual,
            palingLaris: palingLaris,
            trafikMingguan: trafikMingguan,
            listProdukTerjual: listProdukResult.map(item => ({
                nama: item.nama_produk,
                jumlah: item.total_terjual
            }))
        });

    } catch (error) {
        console.error('Error fetching data:', error);
        res.status(500).json({ message: 'Terjadi kesalahan pada server' });
    }
});

// Endpoint untuk Download PDF (Ini hanya kerangka)
app.get('/api/penjualan/download-pdf', async (req, res) => {
    // LOGIKA GENERATE PDF DISINI
    // Anda bisa menggunakan pustaka seperti 'pdfkit' atau 'jspdf' (jika di browser)
    const date = req.query.date || new Date().toISOString().split('T')[0];
    
    // 1. Ambil data penjualan untuk tanggal 'date' (sama seperti endpoint di atas)
    // 2. Generate PDF menggunakan data tersebut
    // 3. Set header untuk download
    // res.setHeader('Content-Type', 'application/pdf');
    // res.setHeader('Content-Disposition', `attachment; filename="Laporan Penjualan ${date}.pdf"`);
    // 4. Kirim PDF
    
    // Placeholder response
    res.status(200).json({ message: `PDF untuk tanggal ${date} siap diunduh (Logika PDF perlu diimplementasikan).` });
});


app.listen(3000, () => {
  console.log('Server berjalan di http://localhost:3000');
});
 
//barang masuk
app.get("/barang-masuk-today", async (req, res) => {
  try {
    const [result] = await pool.execute(
      "SELECT COUNT(*) AS total FROM produk WHERE tanggal = CURDATE()"
    );
    res.json(result[0]);
  } catch (err) {
    res.status(500).send(err);
  }
});

//barang keluar
app.get("/barang-keluar-today", async (req, res) => {
  try {
    const [result] = await pool.execute(
      "SELECT COUNT(*) AS total FROM transaksi WHERE tanggal = CURDATE()"
    );
    res.json(result[0]);
  } catch (err) {
    res.status(500).send(err);
  }
});

//chart tabel
app.get("/chart-weekly", async (req, res) => {
  try {
    const [result] = await pool.execute(
      `SELECT 
          DATE(tanggal) as tgl,
          SUM(CASE WHEN jenis='masuk' THEN jumlah ELSE 0 END) AS masuk,
          SUM(CASE WHEN jenis='keluar' THEN jumlah ELSE 0 END) AS keluar
       FROM (
         SELECT tanggal, jumlah, 'masuk' AS jenis FROM produk
         UNION ALL
         SELECT tanggal, jumlah, 'keluar' AS jenis FROM transaksi
       ) AS data
       WHERE tanggal >= CURDATE() - INTERVAL 6 DAY
       GROUP BY DATE(tanggal)
       ORDER BY tgl ASC`
    );
    res.json(result);
  } catch (err) {
    res.status(500).send(err);
  }
});