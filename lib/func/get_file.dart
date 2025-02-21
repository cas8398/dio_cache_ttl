import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

Future<File?> getCachedFile(
    File file, String folder, String fileName, int ttl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cacheKey = 'DioCache_${folder}_$fileName'; // Unique key

  int? expiryTimestamp = prefs.getInt(cacheKey);
  int now = DateTime.now().millisecondsSinceEpoch;

  if (expiryTimestamp != null && now < expiryTimestamp) {
    if (file.existsSync()) {
      return file; // Return valid cached file
    } else {
      await prefs.remove(cacheKey); // File missing, remove metadata
    }
  }
  return null; // Cache expired or not found
}
