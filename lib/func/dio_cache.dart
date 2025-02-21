import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'get_dir.dart';
import 'get_file.dart';
import 'download_file.dart';
import 'clear_cache.dart';
import 'logger.dart';

/// Downloads and caches a file with the specified extension.
///
/// - [url]: The file URL.
/// - [ttl]: Cache duration.
/// - [extFile]: File extension (e.g., jpg, png, pdf).
/// - [folder]: Storage folder (default: `"default"`).
/// - [showLog]: Enables logging if `true`.
/// - [dio]: Optional Dio instance for testing.
///
/// Returns the downloaded [File].
///
/// Example:
/// ```dart
/// File file = await dioCache(
///   'https://example.com/image/123',
///   ttl: Duration(days: 1),
///   extFile: 'jpg',
///   folder: 'images',
///   showLog: true,
/// );
/// ```
Future<File> dioCache(
  String url, {
  required Duration ttl,
  required String extFile, // extension filename (jpg or png or pdf / etc)
  String? folder = "default",
  bool showLog = false, // Default to false
  Dio? dio, // Inject Dio for testing
}) async {
  int ttlInSeconds = ttl.inSeconds; // Convert Duration to seconds

  if (showLog && kDebugMode) {
    Logger.log('Clearing expired cache for folder: $folder');
  }
  await clearExpiredCache(showLog, folder); // Clear expired cache dynamically

  String dir = await getCacheDirectory(folder);
  String fileName = Uri.parse(url).pathSegments.last;
  File file = File('$dir/$fileName');

  if (showLog && kDebugMode) {
    Logger.log('Checking cache for file: $fileName');
  }

  // Check if cached file exists
  File? cachedFile = await getCachedFile(file, folder!, fileName, ttlInSeconds);
  if (cachedFile != null) {
    if (showLog && kDebugMode) {
      Logger.log('Cache hit: Returning cached file: $fileName');
    }
    return cachedFile; // Return cached file if still valid
  }

  if (showLog && kDebugMode) {
    Logger.error('Cache miss: Downloading file: $fileName');
  }

  // Download and store file, and update cache expiry
  return await downloadFile(
      showLog, url, extFile, file, folder, fileName, ttlInSeconds,
      dio: dio);
}
