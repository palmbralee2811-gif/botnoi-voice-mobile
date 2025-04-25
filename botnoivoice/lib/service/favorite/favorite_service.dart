import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/config/api_url_config.dart';

class FavoriteService {
  final Logger _logger = Logger();

  //สำหรับ Save Favorite
  Future<void> saveFavoriteSpeakers(
    List<String> speakerIds,
    String jwtToken,
  ) async {
    _logger.i('Attempting to save favorite speakers: $speakerIds');

    if (jwtToken.isEmpty) {
      _logger.w('Received empty token for saving.');
      throw Exception('Authentication token provided is empty.');
    }
    _logger.d(
        'Using provided JWT Token for save: Bearer ${jwtToken.substring(0, 10)}...');

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> payload = {
      'speaker_id': speakerIds,
    };
    final String jsonBody = jsonEncode(payload);
    _logger.d('Save Request Body: $jsonBody');

    try {
      final response = await http.post(
        Uri.parse("$apiUrl/api/marketplace/insert_voice_studio"),
        headers: headers,
        body: jsonBody,
      );
      _logger.i('Save API Response Status Code: ${response.statusCode}');
      _logger.d('Save API Response Body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('Successfully saved favorite speakers.');
        return;
      } else {
        _logger.e(
            'Failed to save favorites. Status Code: ${response.statusCode}, Body: ${response.body}');
        throw Exception(
            'Failed to save favorites: [${response.statusCode}] ${response.body}');
      }
    } on http.ClientException catch (e, stackTrace) {
      _logger.e('Network error while saving favorites: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Network error occurred: $e');
    } catch (e, stackTrace) {
      _logger.e('An unexpected error occurred while saving favorites: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ============ เพิ่ม Method นี้สำหรับ Get Favorites ============

  Future<List<String>> getFavoriteSpeakers(String jwtToken) async {
    if (jwtToken.isEmpty) {
      throw Exception('Authentication token provided is empty.');
    }
    _logger
        .d('Using provided JWT Token: Bearer ${jwtToken.substring(0, 10)}...');

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken',
    };
    _logger.d('Get Request Headers: $headers');

    try {
      final response = await http.get(
        Uri.parse("$apiUrl/api/marketplace/get_voice_studio"),
        headers: headers,
      );

      _logger
          .i('Get Favorites API Response Status Code: ${response.statusCode}');
      _logger.d('Get Favorites API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // ===== แก้ไขส่วนนี้: ตรวจสอบ Key "data" และ Parse List =====
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          final dynamic dataValue =
              responseData['data']; // ดึงค่าจาก Key "data"

          if (dataValue is List) {
            final List<dynamic> rawSpeakerList = dataValue;
            try {
              final List<String> favoriteIds = rawSpeakerList
                  .map((item) {
                    if (item is Map<String, dynamic> &&
                        item.containsKey('speaker_id')) {
                      return item['speaker_id']?.toString() ?? '';
                    } else {
                      _logger.w(
                          'Invalid item format found in favorite list: $item');
                      return '';
                    }
                  })
                  .where((id) => id.isNotEmpty)
                  .toList();

              _logger.i(
                  'Successfully fetched and parsed favorite speakers: $favoriteIds');
              return favoriteIds;
            } catch (e, stackTrace) {
              _logger.e('Error parsing speaker list items: $e',
                  error: e, stackTrace: stackTrace);
              throw Exception('Error parsing favorite speaker data.');
            }
          } else {
            _logger.e(
                'Get Favorites response key "data" is not a List. Found: ${dataValue.runtimeType}');
            throw Exception('Invalid response format: "data" is not a list.');
          }
        } else {
          _logger.e(
              'Get Favorites response is not a Map or does not contain key "data". Response: $responseData');
          throw Exception('Invalid response format from Get Favorites API.');
        }
      } else {
        _logger.e(
            'Failed to get favorites via GET. Status Code: ${response.statusCode}, Body: ${response.body}');
        throw Exception(
            'Failed to get favorites via GET: [${response.statusCode}] ${response.body}');
      }
    } on http.ClientException catch (e, stackTrace) {
      _logger.e('Network error while getting favorites: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Network error occurred: $e');
    } catch (e, stackTrace) {
      _logger.e('An unexpected error occurred while getting favorites: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('An unexpected error occurred: $e');
    }
  }
  // ============ จบส่วน Get Favorites ============

  // ========== เพิ่ม Method นี้สำหรับ Delete Favorite ==========

  Future<void> removeFavoriteSpeaker(
    String speakerIdToRemove,
    String jwtToken,
  ) async {
    if (jwtToken.isEmpty) {
      _logger.w('Received empty token for removing favorite.');
      throw Exception('Authentication token provided is empty.');
    }
    _logger.d(
        'Using provided JWT Token for remove: Bearer ${jwtToken.substring(0, 10)}...');

    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken',
    };

    final Map<String, dynamic> payload = {
      'speaker_id': [speakerIdToRemove],
    };
    final String jsonBody = jsonEncode(payload);
    _logger.d('Remove Request Body: $jsonBody');

    try {
      final response = await http.post(
        Uri.parse("$apiUrl/api/marketplace/delete_voice_studio"),
        headers: headers,
        body: jsonBody,
      );

      _logger.i(
          'Remove Favorite API Response Status Code: ${response.statusCode}');
      _logger.d('Remove Favorite API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('Successfully removed favorite speaker: $speakerIdToRemove');
        return;
      } else {
        _logger.e(
            'Failed to remove favorite. Status Code: ${response.statusCode}, Body: ${response.body}');
        throw Exception(
            'Failed to remove favorite: [${response.statusCode}] ${response.body}');
      }
    } on http.ClientException catch (e, stackTrace) {
      _logger.e('Network error while removing favorite: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Network error occurred: $e');
    } catch (e, stackTrace) {
      _logger.e('An unexpected error occurred while removing favorite: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('An unexpected error occurred: $e');
    }
  }
}