
import 'package:flutter/material.dart';

import 'helpers/hive_helper.dart';
import 'helpers/pengaturan_helper.dart';
import 'pages/halaman_utama.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive dan membuka Box laporan
  await HiveHelper.init();

  // Inisialisasi SharedPreferences
  await PengaturanHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pelaporan Fasilitas Kota',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}
