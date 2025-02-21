import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cache_ttl/dio_cache_ttl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testCacheDir;
  late MockDio mockDio;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    // Mock `getTemporaryDirectory`
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return Directory.systemTemp.path;
      },
    );

    // Create a test cache directory
    testCacheDir = Directory.systemTemp.createTempSync('dio_cache_test');
    mockDio = MockDio();
  });

  tearDownAll(() {
    if (testCacheDir.existsSync()) {
      testCacheDir.deleteSync(recursive: true);
    }
  });

  test('dioCache should return a cached file', () async {
    // Mock the Dio response
    when(() => mockDio.get<List<int>>(any(), options: any(named: 'options')))
        .thenAnswer(
      (_) async => Response<List<int>>(
        requestOptions: RequestOptions(
            path:
                'https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf'),
        statusCode: 200,
        data: List<int>.filled(100, 0), // Mock binary file data
      ),
    );

    File file = await dioCache(
      "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf",
      ttl: Duration(seconds: 10),
      dio: mockDio, // Pass the mocked Dio instance
    );

    expect(file.existsSync(), true);
  });
}
