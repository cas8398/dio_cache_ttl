import 'dart:io';
import 'package:dio/dio.dart';

import 'get_dir.dart';
import 'get_file.dart';
import 'download_file.dart';
import 'clear_cache.dart';

/// Function to handle caching with Dio
Future<File> dioCache(
  String url, {
  required Duration ttl,
  String? folder,
  Dio? dio, // Inject Dio for testing
}) async {
  int ttlInSeconds = ttl.inSeconds; // Convert Duration to seconds
  await clearExpiredCache(folder); // Clear expired cache dynamically

  String dir = await getCacheDirectory(folder); // Dynamic folder
  String fileName = Uri.parse(url).pathSegments.last;
  File file = File('$dir/$fileName');

  // Check if cached file exists
  File? cachedFile =
      await getCachedFile(file, folder ?? "default", fileName, ttlInSeconds);
  if (cachedFile != null) {
    return cachedFile; // Return cached file if still valid
  }

  // Download and store file, and update cache expiry
  return await downloadFile(
      url, file, folder ?? "default", fileName, ttlInSeconds,
      dio: dio);
}
