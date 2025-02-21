import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Function to download a file and save it
Future<File> downloadFile(
  String url,
  File file,
  String folder,
  String fileName,
  int ttl, {
  Dio? dio, // Inject Dio for testing
}) async {
  dio ??= Dio(); // Use existing Dio instance or create a new one

  try {
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    await file.writeAsBytes(response.data!);

    // Store cache expiry in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expiryTimestamp = DateTime.now().millisecondsSinceEpoch + (ttl * 1000);
    await prefs.setInt('dio_cache_${folder}_$fileName', expiryTimestamp);

    return file;
  } catch (e) {
    throw Exception("Failed to download file: $e");
  }
}
