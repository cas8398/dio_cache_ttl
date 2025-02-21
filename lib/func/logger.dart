import 'package:flutter/foundation.dart';
import 'dart:convert';

class Logger {
  static const int _maxLength = 300; // Limit log length for long messages

  static void log(dynamic message) {
    _printLog('📝 LOG', message);
  }

  static void warn(dynamic message) {
    _printLog('⚠️ WARNING', message);
  }

  static void error(dynamic message, [Object? error, StackTrace? stackTrace]) {
    _printLog('❌ ERROR', message);
    if (kDebugMode) {
      if (error != null) print('🔴 Error: $error');
      if (stackTrace != null) print('📜 StackTrace: $stackTrace');
    }
  }

  static void _printLog(String level, dynamic message) {
    if (!kDebugMode) return;

    String formattedMessage = _formatMessage(message);
    print('[$level] - $formattedMessage');
  }

  static String _formatMessage(dynamic message) {
    if (message is Map || message is List) {
      message = const JsonEncoder.withIndent('  ')
          .convert(message); // Pretty-print JSON
    } else {
      message = message.toString();
    }

    // Limit long messages
    if (message.length > _maxLength) {
      return '${message.substring(0, _maxLength)}... [Truncated]';
    }
    return message;
  }
}
