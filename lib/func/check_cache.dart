import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'get_dir.dart';
import 'logger.dart';

const Uuid uuid = Uuid();

/// Checks if a URL is already cached and returns the file if valid.
Future<File?> checkCachedFile(
  bool showLog,
  String url,
  String folder,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cachedFileName = prefs.getString('DioCache_${folder}_$url');

  if (cachedFileName == null) {
    if (showLog) Logger.log('❌ No cache entry found for $url');
    return null;
  }

  String cacheDir = await getCacheDirectory(folder);
  File cachedFile = File('$cacheDir/$cachedFileName');

  if (!cachedFile.existsSync()) {
    if (showLog) Logger.log('❌ Cached file missing: $cachedFileName');
    return null;
  }

  if (showLog) Logger.log('✅ Cache hit: Returning cached file $cachedFileName');
  return cachedFile;
}
