// ignore_for_file: unused_element

/// API URL for the production server
String _productionUrl = "https://api-voice.botnoi.ai";

/// API URL for the staging server (FOR TESTING)
String _stagingUrl = "https://api-voice-staging.botnoi.ai";

/// Base API URL for the current environment (Production or Staging)
String get baseApiUrl => _productionUrl;