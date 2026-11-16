
import 'package:hive_flutter/hive_flutter.dart';

import '../models/laporan_fasilitas.dart';

class HiveHelper {
  HiveHelper._();

  static const String namaBox = 'laporanFasilitasBox';

  static late Box<LaporanFasilitas> laporanBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LaporanFasilitasAdapter());
    }

    laporanBox = await Hive.openBox<LaporanFasilitas>(namaBox);
  }
}
