import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

/// Function to download a file and save it
Future<File> downloadFile(
  bool showLog, // Logging flag
  String url,
  String extFile, // Required file extension (e.g., jpg, png, pdf)
  File file,
  String folder,
  String fileName,
  int ttl, {
  Dio? dio, // Inject Dio for testing
}) async {
  dio ??= Dio(); // Use existing Dio instance or create a new one

  if (showLog) {
    Logger.log('📥 Downloading: $url');
  }

  try {
    final response = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true, // Follow redirects properly
      ),
    );

    // Get the final redirected URL
    Uri finalUri = response.realUri;

    // Try to extract filename from Content-Disposition header
    String? newFileName = _extractFileName(response);

    // If no filename found, try from URL
    if (newFileName == null || newFileName.isEmpty) {
      newFileName = p.basename(finalUri.path);
    }

    // Ensure file extension is correct
    if (!newFileName.contains('.')) {
      newFileName = '$newFileName.$extFile'; // Use provided extension
    }

    // Construct the final file path
    String finalFilePath = '${file.parent.path}/$newFileName';
    File finalFile = File(finalFilePath);

    // Save file
    await finalFile.writeAsBytes(response.data!);

    if (showLog) {
      Logger.log('✅ File saved: $finalFilePath');
    }

    // Store cache expiry in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expiryTimestamp = DateTime.now().millisecondsSinceEpoch + (ttl * 1000);
    await prefs.setInt('dio_cache_${folder}_$newFileName', expiryTimestamp);

    if (showLog) {
      Logger.warn('🕒 Cache expiry set for: $newFileName');
    }

    return finalFile;
  } catch (e) {
    if (showLog) {
      Logger.error('❌ Failed to download: $e');
    }
    throw Exception("Failed to download file: $e");
  }
}

/// Extracts filename from `Content-Disposition` header if available
String? _extractFileName(Response response) {
  String? contentDisposition = response.headers.value('content-disposition');
  if (contentDisposition != null && contentDisposition.contains('filename=')) {
    final match =
        RegExp(r'filename="?([^"]+)"?').firstMatch(contentDisposition);
    return match?.group(1);
  }
  return null;
}
