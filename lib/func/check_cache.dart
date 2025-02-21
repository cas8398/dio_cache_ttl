import 'dart:io';
import 'better_name.dart';
import 'get_dir.dart';
import 'logger.dart';

/// Checks if a URL is already cached and returns the file if valid.
Future<File?> checkCachedFile(
  bool showLog,
  String url,
  String folder,
  int ttl, // TTL in seconds
  String extFile,
) async {
  String cacheDir = await getCacheDirectory(folder);
  Directory dir = Directory(cacheDir);

  if (!dir.existsSync()) {
    if (showLog) Logger.log('📂 Cache directory does not exist: $cacheDir');
    return null;
  }

  String generateName = encodeFileName(url);
  String expectedFileName = '$generateName.$extFile';
  File cachedFile = File('$cacheDir/$expectedFileName');

  if (!cachedFile.existsSync()) {
    if (showLog) Logger.log('❌ No cache entry found for $url');
    return null;
  }

  DateTime lastModified = cachedFile.lastModifiedSync();
  DateTime expiryTime = lastModified.add(Duration(seconds: ttl));
  DateTime now = DateTime.now();

  if (expiryTime.isBefore(now)) {
    if (showLog) Logger.log('❌ Cached file expired: $expectedFileName');
    return null;
  }

  if (showLog) {
    Logger.log('✅ Cache hit: Returning cached file $expectedFileName');
  }
  return cachedFile;
}
