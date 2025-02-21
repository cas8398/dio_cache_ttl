import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'logger.dart';

/// Clears expired cache files in the specified folder.
Future<void> clearExpiredCache(bool showLog, [String? folder]) async {
  Directory baseDir = await getTemporaryDirectory();
  final cacheDir = Directory('${baseDir.path}/Dio_Cache/$folder');

  if (!cacheDir.existsSync()) {
    if (showLog) {
      Logger.log('🗂️ Cache directory does not exist: ${cacheDir.path}');
    }
    return;
  }

  for (var file in cacheDir.listSync()) {
    try {
      file.deleteSync(recursive: true);
      if (showLog) Logger.log('🗑️ Deleted expired cache: ${file.path}');
    } catch (e) {
      if (showLog) Logger.error('❌ Error deleting file: ${file.path}', e);
    }
  }

  if (showLog) Logger.log('✅ Cache cleanup completed in: ${cacheDir.path}');
}
