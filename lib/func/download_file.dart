import 'dart:io';
import 'package:dio/dio.dart';
import 'better_name.dart';
import 'get_dir.dart';
import 'logger.dart';

/// Downloads a file, saves it with a unique name, and caches it.
Future<File> downloadFile(
  bool showLog,
  String url,
  String extFile,
  String folder,
  int ttl, {
  Dio? dio,
}) async {
  dio ??= Dio();

  if (showLog) {
    Logger.log('📥 Downloading: $url');
  }

  try {
    final response = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
      ),
    );

    // Save file to cache
    File cachedFile = await saveToCache(
      showLog,
      url,
      response.data!,
      extFile,
      folder,
    );

    if (showLog) {
      Logger.log('✅ File saved: ${cachedFile.path}');
    }

    return cachedFile;
  } catch (e) {
    if (showLog) {
      Logger.error('❌ Failed to download: $e');
    }
    throw Exception("Failed to download file: $e");
  }
}

/// Saves file to cache with a recognizable name.
Future<File> saveToCache(
  bool showLog,
  String url,
  List<int> data,
  String extFile,
  String folder,
) async {
  String cacheDir = await getCacheDirectory(folder);
  Directory(cacheDir).createSync(recursive: true);

  // Use encoded URL as filename
  String generateName = encodeFileName(url);
  String fileName = '$generateName.$extFile';
  String filePath = '$cacheDir/$fileName';
  File file = File(filePath);

  // Write file
  await file.writeAsBytes(data);

  if (showLog) {
    Logger.log('📌 Cached file: $fileName');
    Logger.log('📂 Saved in folder: $folder');
    Logger.log('⏳ File modified time set to: ${file.lastModifiedSync()}');
  }

  return file;
}
