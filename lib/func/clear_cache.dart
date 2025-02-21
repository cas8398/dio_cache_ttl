import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

/// Clears expired cache files in the specified folder.
Future<void> clearExpiredCache(bool showLog, [String? folder]) async {
  Directory baseDir = await getTemporaryDirectory();
  final cacheDir = Directory('${baseDir.path}/DioCache/$folder');

  if (!cacheDir.existsSync()) {
    if (showLog) {
      Logger.log('📂 Cache directory does not exist: ${cacheDir.path}');
    }
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int now = DateTime.now().millisecondsSinceEpoch;

  for (var file in cacheDir.listSync()) {
    String fileName = file.uri.pathSegments.last;
    int? expiryTimestamp = prefs.getInt('DioCache_${folder}_$fileName');

    if (expiryTimestamp == null || expiryTimestamp < now) {
      try {
        file.deleteSync();
        prefs.remove('DioCache_${folder}_$fileName'); // Remove expired entry
        if (showLog) Logger.log('🗑️ Deleted expired cache: ${file.path}');
      } catch (e) {
        if (showLog) Logger.error('❌ Error deleting file: ${file.path}', e);
      }
    }
  }

  if (showLog) Logger.log('✅ Cache cleanup completed in: ${cacheDir.path}');
}
