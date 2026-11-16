
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanHelper {
  PengaturanHelper._();

  static const String _keyFilter = 'filter_status_laporan';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String muatFilter() {
    return _prefs.getString(_keyFilter) ?? 'Semua';
  }

  static Future<void> simpanFilter(String status) async {
    await _prefs.setString(_keyFilter, status);
  }

  static Future<void> resetFilter() async {
    await _prefs.remove(_keyFilter);
  }
}
