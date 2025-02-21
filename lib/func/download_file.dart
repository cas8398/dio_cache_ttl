import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'get_dir.dart';
import 'logger.dart';

const Uuid uuid = Uuid();

/// Downloads a file, assigns a unique filename, and caches it.
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
      ttl,
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

/// Saves file to cache with a UUID filename.
Future<File> saveToCache(
  bool showLog,
  String url,
  List<int> data,
  String extFile,
  String folder,
  int ttl,
) async {
  String cacheDir = await getCacheDirectory(folder);
  Directory(cacheDir).createSync(recursive: true);

  // Generate a UUID filename
  String uuidFileName = '${uuid.v4()}.$extFile';
  String filePath = '$cacheDir/$uuidFileName';
  File file = File(filePath);

  // Write file
  await file.writeAsBytes(data);

  // Save cache metadata
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int expiryTimestamp = DateTime.now().millisecondsSinceEpoch + (ttl * 1000);
  await prefs.setString('DioCache_${folder}_$url', uuidFileName);
  await prefs.setInt('DioCacheExpiry_${folder}_$url', expiryTimestamp);

  if (showLog) {
    DateTime expiryTime = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    Logger.log('📌 Cached file: $uuidFileName');
    Logger.log('📂 Saved in folder: $folder');
    Logger.log('⏳ Cache expiry: $expiryTime (${ttl}s from now)');
  }

  return file;
}
