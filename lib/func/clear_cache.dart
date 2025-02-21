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
  List<String> keysToRemove = [];

  // Iterate over all keys in SharedPreferences
  for (String key in prefs.getKeys()) {
    if (!key.startsWith('DioCacheExpiry_') ||
        (folder != null && !key.contains('_$folder'))) {
      continue; // Ignore unrelated keys
    }

    int? expiryTimestamp = prefs.getInt(key);
    Logger.log(
        '🔍 Checking cache key: $key with expiry: $expiryTimestamp (Now: $now)');

    if (expiryTimestamp == null || expiryTimestamp < now) {
      String urlKey = key.replaceFirst('DioCacheExpiry_', 'DioCache_');
      String? cachedFileName = prefs.getString(urlKey);

      if (cachedFileName != null) {
        File cachedFile = File('${cacheDir.path}/$cachedFileName');
        Logger.log(
            '🔍 Checking file: ${cachedFile.path} - Exists: ${cachedFile.existsSync()}');

        if (cachedFile.existsSync()) {
          try {
            await cachedFile.delete();
            if (showLog) {
              Logger.log('🗑️ Deleted expired cache: ${cachedFile.path}');
            }
          } catch (e) {
            if (showLog) {
              Logger.error('❌ Error deleting file: ${cachedFile.path}', e);
            }
          }
        }
      }

      // Mark keys for removal
      keysToRemove.add(key);
      keysToRemove.add(urlKey);
    }
  }

  // Remove expired keys from SharedPreferences
  for (String key in keysToRemove) {
    prefs.remove(key);
  }

  if (showLog) {
    Logger.log('✅ Cache cleanup completed for folder: ${cacheDir.path}');
  }
}
