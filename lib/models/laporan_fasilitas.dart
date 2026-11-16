
import 'package:hive/hive.dart';

part 'laporan_fasilitas.g.dart';

@HiveType(typeId: 0)
class LaporanFasilitas extends HiveObject {
  @HiveField(0)
  String kode;

  @HiveField(1)
  String jenis;

  @HiveField(2)
  String lokasi;

  @HiveField(3)
  String status;

  LaporanFasilitas({
    required this.kode,
    required this.jenis,
    required this.lokasi,
    required this.status,
  });
}
