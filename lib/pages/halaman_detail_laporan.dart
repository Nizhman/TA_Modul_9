
import 'package:flutter/material.dart';
import '../models/laporan_fasilitas.dart';

class HalamanDetailLaporan extends StatelessWidget {
  final LaporanFasilitas laporan;

  const HalamanDetailLaporan({
    super.key,
    required this.laporan,
  });

  Color _warnaStatus() {
    switch (laporan.status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.description_outlined,
              size: 90,
              color: Colors.teal,
            ),

            const SizedBox(height: 16),

            const Text(
              'Informasi Laporan Fasilitas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 28),

            _itemDetail(
              'Kode Laporan',
              laporan.kode,
              Icons.tag,
            ),

            _itemDetail(
              'Jenis Laporan',
              laporan.jenis,
              Icons.report_problem_outlined,
            ),

            _itemDetail(
              'Lokasi',
              laporan.lokasi,
              Icons.location_on_outlined,
            ),

            const SizedBox(height: 12),

            const Text(
              'Status Laporan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _warnaStatus().withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  laporan.status,
                  style: TextStyle(
                    color: _warnaStatus(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDetail(
    String judul,
    String isi,
    IconData ikon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(ikon, color: Colors.teal),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
