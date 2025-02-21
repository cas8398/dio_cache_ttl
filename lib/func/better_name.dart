import 'dart:convert';

/// Generate a unique, reversible filename from a URL
String encodeFileName(String url) {
  // Remove http://, https://, and www.
  String cleanedUrl = url.replaceFirst(RegExp(r'^https?:\/\/(www\.)?'), '');

  // Base64 URL-safe encoding without padding
  return base64UrlEncode(utf8.encode(cleanedUrl)).replaceAll('=', '');
}

String decodeFileName(String encoded) {
  // Restore padding before decoding
  String padded = encoded.padRight((encoded.length + 3) ~/ 4 * 4, '=');
  return utf8.decode(base64Url.decode(padded));
}
