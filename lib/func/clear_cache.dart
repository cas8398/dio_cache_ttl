import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

/// Clears expired cache files in the specified folder.
Future<void> clearExpiredCache(bool showLog, int ttl, [String? folder]) async {
  Directory baseDir = await getTemporaryDirectory();
  final cacheDir = Directory('${baseDir.path}/DioCache/$folder');

  if (!cacheDir.existsSync()) {
    if (showLog) {
      Logger.log('📂 Cache directory does not exist: ${cacheDir.path}');
    }
    return;
  }

  DateTime now = DateTime.now();

  for (FileSystemEntity entity in cacheDir.listSync()) {
    if (entity is File) {
      DateTime lastModified = entity.lastModifiedSync();
      DateTime expiryTime = lastModified.add(Duration(seconds: ttl));

      if (expiryTime.isBefore(now)) {
        try {
          entity.deleteSync();
          if (showLog) Logger.log('🗑️ Deleted expired cache: ${entity.path}');
        } catch (e) {
          if (showLog) Logger.error('❌ Error deleting file: ${entity.path}', e);
        }
      }
    }
  }

  if (showLog) {
    Logger.log('✅ Cache cleanup completed for folder: ${cacheDir.path}');
  }
}
