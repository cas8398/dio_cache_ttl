import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'download_file.dart';
import 'clear_cache.dart';
import 'check_cache.dart';
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

  await checkCachedFile(showLog, url, extFile);

  // Download and store file
  return await downloadFile(showLog, url, extFile, folder!, ttlInSeconds,
      dio: dio);
}
