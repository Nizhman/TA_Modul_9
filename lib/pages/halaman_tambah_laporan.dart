
import 'package:flutter/material.dart';

import '../helpers/hive_helper.dart';
import '../models/laporan_fasilitas.dart';

class HalamanTambahLaporan extends StatefulWidget {
  const HalamanTambahLaporan({super.key});

  @override
  State<HalamanTambahLaporan> createState() =>
      _HalamanTambahLaporanState();
}

class _HalamanTambahLaporanState
    extends State<HalamanTambahLaporan> {
  final _formKey = GlobalKey<FormState>();

  final _kodeController = TextEditingController();
  final _jenisController = TextEditingController();
  final _lokasiController = TextEditingController();

  bool _sedangMenyimpan = false;

  @override
  void dispose() {
    _kodeController.dispose();
    _jenisController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _simpanLaporan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final kode = _kodeController.text.trim();
    final jenis = _jenisController.text.trim();
    final lokasi = _lokasiController.text.trim();

    if (HiveHelper.laporanBox.containsKey(kode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode laporan sudah digunakan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _sedangMenyimpan = true;
    });

    try {
      final laporan = LaporanFasilitas(
        kode: kode,
        jenis: jenis,
        lokasi: lokasi,
        status: 'Baru',
      );

      await HiveHelper.laporanBox.put(kode, laporan);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil ditambahkan.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan laporan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Laporan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.report_problem_outlined,
                size: 72,
                color: Colors.teal,
              ),
              const SizedBox(height: 12),
              const Text(
                'Formulir Laporan Fasilitas Kota',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _kodeController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Kode Laporan',
                  hintText: 'Contoh: SC01',
                  prefixIcon: Icon(Icons.tag),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode laporan wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _jenisController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Jenis Laporan',
                  hintText: 'Contoh: Lampu jalan mati',
                  prefixIcon: Icon(Icons.report),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jenis laporan wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _lokasiController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  hintText: 'Contoh: Jl. Melati',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lokasi wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed:
                    _sedangMenyimpan ? null : _simpanLaporan,
                icon: _sedangMenyimpan
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _sedangMenyimpan
                      ? 'Menyimpan...'
                      : 'Simpan Laporan',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
