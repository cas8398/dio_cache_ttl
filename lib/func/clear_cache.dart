import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> clearExpiredCache([String? folder]) async {
  final baseDir = await getTemporaryDirectory();
  final cacheDir = Directory('${baseDir.path}/${folder ?? "dio_cache"}');

  if (cacheDir.existsSync()) {
    for (var file in cacheDir.listSync()) {
      try {
        file.deleteSync(recursive: true);
      } catch (e) {
        print('Error deleting file: $e');
      }
    }
  }
}
