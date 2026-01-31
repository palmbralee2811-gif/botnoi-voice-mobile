/*
NOTE: This File for Global Configuration Switch Between Staging or Production
*/

/// API URL for the production server
String _productionUrl = "https://api-voice.botnoi.ai";

/// API URL for the staging server (FOR TESTING)
String _stagingUrl = "https://api-voice-staging.botnoi.ai";

/// Referer URL for the production server
String _productionRefererUrl = "https://voice.botnoi.ai/";

/// Referer URL for the staging server
String _stagingRefererUrl = "https://voice-staging.botnoi.ai/";

/// Returns the API URL for the current environment (Production or Staging)
String get apiUrl => _productionUrl;

/// Returns the Referer URL for the current environment (Production or Staging)
String get refererUrl => _productionRefererUrl;

/// Check if the app is running in debugging mode
bool get isDebuggingMode {
  return apiUrl == _stagingUrl || refererUrl == _stagingRefererUrl;
}
