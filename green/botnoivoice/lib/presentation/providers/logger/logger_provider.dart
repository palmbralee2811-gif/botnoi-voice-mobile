import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoggerProvider with ChangeNotifier {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  Logger get logger => _logger;
}
