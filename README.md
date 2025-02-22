# dio_cache_ttl

A library caching solution with Time-to-Live (TTL) support, enabling efficient storage and retrieval of HTTP responses using the file system. Ideal for optimizing network performance and reducing redundant requests.

## Features

- ✅ Cache files locally with a specified TTL
- ✅ Uses Dio for efficient downloading
- ✅ Automatically clears expired cache
- ✅ Supports custom cache directories

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  dio_cache_ttl: ^0.3.3
```

Or add via CLI:

```sh
flutter pub add dio_cache_ttl
```

```yaml
dependencies:
  dio_cache_ttl:
    git:
      url: https://github.com/cas8938/dio_cache_ttl.git
```

## Usage

### Import the package

```dart
import 'package:dio_cache_ttl/dio_cache_ttl.dart';
```

### Cache a file

```dart
import 'dart:io';
import 'package:dio_cache_ttl/dio_cache_ttl.dart';

void main() async {
  File file = await dioCache(
    "https://example.com/sample.pdf",
    extFile: "pdf",
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

This project is licensed under the MIT License - see the [LICENSE](https://github.com/cas8398/dio_cache_ttl/blob/master/LICENSE) file for details.
