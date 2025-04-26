import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/config/api_url_config.dart';

// This class helps you save, get, and remove your favorite speakers.
// It talks to a server using the internet.
class FavoriteService {
  final Logger _logger;
  final http.Client _httpClient;

  // These are the server paths we need to call.
  static const _insertEndpoint = "/api/marketplace/insert_voice_studio";
  static const _getEndpoint = "/api/marketplace/get_voice_studio";
  static const _deleteEndpoint = "/api/marketplace/delete_voice_studio";

  // How long we wait before giving up (10 seconds)
  static const Duration _timeoutDuration = Duration(seconds: 10);
  // How many times we try if something goes wrong
  static const int _maxRetries = 3;

  // You can give a custom logger and http client, or we use the default ones.
  FavoriteService({Logger? logger, http.Client? httpClient})
      : _logger = logger ?? Logger(),
        _httpClient = httpClient ?? http.Client();

  // This makes headers (special notes) for our internet message.
  Map<String, String> _buildHeaders(String token, {bool isJson = true}) {
    if (token.isEmpty) {
      _logger.w('Received empty token.');
      throw Exception('Authentication token is empty.');
    }
    return {
      if (isJson) 'Content-Type': 'application/json; charset=UTF-8',
      'Accept-Charset': 'utf-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // This sends a POST request (like sending a letter to the server)
  Future<http.Response> _postRequest(String endpoint, Map<String, dynamic> body, String token) async {
    final headers = _buildHeaders(token);
    final url = Uri.parse("$apiUrl$endpoint");
    final bodyJson = utf8.encode(jsonEncode(body));

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        _logger.d('POST Attempt ${attempt + 1}: $url\nHeaders: $headers\nBody: $body');
        final response = await _httpClient
            .post(url, headers: headers, body: bodyJson)
            .timeout(_timeoutDuration);
        _logResponse(response);
        return response;
      } on TimeoutException catch (e) {
        _logger.w('Timeout on attempt ${attempt + 1} POST $url: $e');
        if (attempt == _maxRetries - 1) rethrow;
      } on http.ClientException catch (e, stackTrace) {
        _handleException('POST', url.toString(), e, stackTrace);
        if (attempt == _maxRetries - 1) rethrow;
      } catch (e, stackTrace) {
        _handleException('POST', url.toString(), e, stackTrace);
        rethrow;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    throw Exception('POST $url failed after $_maxRetries attempts.');
  }

  // This sends a GET request (like asking for information from the server)
  Future<http.Response> _getRequest(String endpoint, String token) async {
    final headers = _buildHeaders(token, isJson: false);
    final url = Uri.parse("$apiUrl$endpoint");

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        _logger.d('GET Attempt ${attempt + 1}: $url\nHeaders: $headers');
        final response = await _httpClient
            .get(url, headers: headers)
            .timeout(_timeoutDuration);
        _logResponse(response);
        return response;
      } on TimeoutException catch (e) {
        _logger.w('Timeout on attempt ${attempt + 1} GET $url: $e');
        if (attempt == _maxRetries - 1) rethrow;
      } on http.ClientException catch (e, stackTrace) {
        _handleException('GET', url.toString(), e, stackTrace);
        if (attempt == _maxRetries - 1) rethrow;
      } catch (e, stackTrace) {
        _handleException('GET', url.toString(), e, stackTrace);
        rethrow;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
    throw Exception('GET $url failed after $_maxRetries attempts.');
  }

  // This shows the response (server's answer) in our log
  void _logResponse(http.Response response) {
    _logger.i('Response Status: ${response.statusCode}');
    _logger.d('Response Body: ${utf8.decode(response.bodyBytes)}');
  }

  // This handles and logs any errors that happen
  void _handleException(String method, String url, Object error, StackTrace stackTrace) {
    _logger.e('Network error during $method $url: $error', error: error, stackTrace: stackTrace);
  }

  // This function saves the speakers you like to the server
  Future<void> saveFavoriteSpeakers(List<String> speakerIds, String jwtToken) async {
    final response = await _postRequest(
      _insertEndpoint,
      { 'speaker_id': speakerIds },
      jwtToken,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save favorites: [${response.statusCode}] ${utf8.decode(response.bodyBytes)}');
    }
  }

  // This function asks the server which speakers you liked
  Future<List<String>> getFavoriteSpeakers(String jwtToken) async {
    final response = await _getRequest(_getEndpoint, jwtToken);

    if (response.statusCode != 200) {
      throw Exception('Failed to get favorites: [${response.statusCode}] ${utf8.decode(response.bodyBytes)}');
    }

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      final data = responseData['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((item) => item['speaker_id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
      }
      throw Exception('Invalid response format: "data" is not a list.');
    }
    throw Exception('Invalid response format: missing "data" key.');
  }

  // This function removes a speaker from your favorite list
  Future<void> removeFavoriteSpeaker(String speakerId, String jwtToken) async {
    final response = await _postRequest(
      _deleteEndpoint,
      { 'speaker_id': [speakerId] },
      jwtToken,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite: [${response.statusCode}] ${utf8.decode(response.bodyBytes)}');
    }
  }
}
