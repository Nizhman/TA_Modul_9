
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';
import '../models/laporan_fasilitas.dart';
import 'halaman_tambah_laporan.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  String _filterStatus = 'Semua';

  final List<String> _pilihanStatus = [
    'Semua',
    'Baru',
    'Diproses',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();

    _filterStatus = PengaturanHelper.muatFilter();

    if (!_pilihanStatus.contains(_filterStatus)) {
      _filterStatus = 'Semua';
    }
  }

  // Mengubah dan menyimpan filter status
  Future<void> _ubahFilter(String? status) async {
    if (status == null) return;

    setState(() {
      _filterStatus = status;
    });

    await PengaturanHelper.simpanFilter(status);
  }

  // Mengubah status laporan
  Future<void> _ubahStatus(LaporanFasilitas laporan) async {
    final statusBaru = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Ubah Status Laporan'),
          children: [
            for (final status in [
              'Baru',
              'Diproses',
              'Selesai',
            ])
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(dialogContext, status);
                },
                child: Text(status),
              ),
          ],
        );
      },
    );

    if (statusBaru == null) return;

    await HiveHelper.laporanBox.put(
      laporan.kode,
      LaporanFasilitas(
        kode: laporan.kode,
        jenis: laporan.jenis,
        lokasi: laporan.lokasi,
        status: statusBaru,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status laporan ${laporan.kode} berhasil diubah.',
        ),
      ),
    );
  }

  // Menghapus laporan dengan konfirmasi
  Future<void> _hapusLaporan(LaporanFasilitas laporan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Laporan?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus laporan ${laporan.kode}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) return;

    await HiveHelper.laporanBox.delete(laporan.kode);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil dihapus.'),
      ),
    );
  }

  // Menentukan warna berdasarkan status
  Color _warnaStatus(String status) {
    switch (status) {
      case 'Baru':
        return Colors.blue;
      case 'Diproses':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Menampilkan detail laporan
  void _lihatDetail(LaporanFasilitas laporan) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(laporan.jenis),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kode: ${laporan.kode}'),
              const SizedBox(height: 8),
              Text('Lokasi: ${laporan.lokasi}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Status: '),
                  Text(
                    laporan.status,
                    style: TextStyle(
                      color: _warnaStatus(laporan.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Membuka halaman tambah laporan
  Future<void> _bukaHalamanTambah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanTambahLaporan(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelaporan Fasilitas Kota'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Filter status laporan
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _filterStatus,
              decoration: const InputDecoration(
                labelText: 'Filter Status Laporan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list),
              ),
              items: _pilihanStatus.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: _ubahFilter,
            ),
          ),

          // Daftar laporan dari Hive
          Expanded(
            child: ValueListenableBuilder<Box<LaporanFasilitas>>(
              valueListenable: HiveHelper.laporanBox.listenable(),
              builder: (context, box, _) {
                final semuaLaporan = box.values.toList();

                final daftarLaporan = _filterStatus == 'Semua'
                    ? semuaLaporan
                    : semuaLaporan.where((laporan) {
                        return laporan.status == _filterStatus;
                      }).toList();

                // Tampilan ketika laporan kosong
                if (daftarLaporan.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _filterStatus == 'Semua'
                              ? 'Belum ada laporan'
                              : 'Tidak ada laporan dengan status $_filterStatus',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  itemCount: daftarLaporan.length,
                  itemBuilder: (context, index) {
                    final laporan = daftarLaporan[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: const Icon(
                            Icons.location_city,
                          ),
                        ),

                        title: Text(
                          laporan.jenis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kode: ${laporan.kode}'),
                              Text('Lokasi: ${laporan.lokasi}'),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _warnaStatus(
                                    laporan.status,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  laporan.status,
                                  style: TextStyle(
                                    color: _warnaStatus(
                                      laporan.status,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        isThreeLine: true,

                        // Menu ubah status dan hapus
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Aksi laporan',
                          onSelected: (aksi) {
                            if (aksi == 'ubah') {
                              _ubahStatus(laporan);
                            } else if (aksi == 'hapus') {
                              _hapusLaporan(laporan);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'ubah',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined),
                                  SizedBox(width: 8),
                                  Text('Ubah Status'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'hapus',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline),
                                  SizedBox(width: 8),
                                  Text('Hapus Laporan'),
                                ],
                              ),
                            ),
                          ],
                        ),

                        onTap: () {
                          _lihatDetail(laporan);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Tombol tambah laporan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaHalamanTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Laporan'),
      ),
    );
  }
}
