# dio_cache_ttl

A Flutter package for caching files using Dio with Time-to-Live (TTL) support.

## Features

- Cache files locally with a specified TTL.
- Uses `Dio` for downloading.
- Automatically clears expired cache.
- Supports custom cache directories.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  dio_cache_ttl:
    git:
      url: https://github.com/YOUR_GITHUB_USERNAME/dio_cache_ttl.git
```

Or add via CLI:

```sh
flutter pub add dio_cache_ttl
```

## Usage

### Import the package

```dart
import 'package:dio_cache_ttl/dio_cache_ttl.dart';
```

### Cache a file

```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_ttl/dio_cache_ttl.dart';

void main() async {
  File file = await dioCache(
    "https://example.com/sample.pdf",
    ttl: Duration(hours: 1), // Cache for 1 hour
  );
  print("File saved at: ${file.path}");
}
```

## Testing

Run tests using:

```sh
flutter test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
