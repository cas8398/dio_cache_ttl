import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getCacheDirectory(String? subFolder) async {
  Directory tempDir = await getTemporaryDirectory();
  String dirPath =
      subFolder != null ? '${tempDir.path}/$subFolder' : tempDir.path;

  Directory dir = Directory(dirPath);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  return dirPath;
}
