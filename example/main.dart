import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_ttl/dio_cache_ttl.dart';

void main() async {
  const url =
      'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
  const cacheDuration = Duration(minutes: 5);

  try {
    File file = await dioCache(url, extFile: "pdf", ttl: cacheDuration);
    print('File downloaded and cached at: ${file.path}');
  } catch (e) {
    print('Error: $e');
  }
}
