import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/voiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/Model/speaker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketplaceWidget extends StatefulWidget {
  const MarketplaceWidget({Key? key});

  @override
  _MarketplaceWidgetState createState() => _MarketplaceWidgetState();
}

class _MarketplaceWidgetState extends State<MarketplaceWidget> {
  bool isAudioPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  late Future<List<Speaker>> _fetchMarketplaceDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchMarketplaceDataFuture = _fetchData();
  }

  Future<List<Speaker>> _fetchData() async {
    // Attempt to load data from cache
    List<Speaker>? cachedData = await _loadDataFromCache();
    if (cachedData != null && cachedData.isNotEmpty) {
      return cachedData;
    } else {
      // If no cached data, fetch from network
      return fetchMarketplaceData();
    }
  }

  Future<List<Speaker>> fetchMarketplaceData() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? jwtToken = auth.idTokenWithFirebase;

    if (jwtToken != null) {
      String? data = await getAllMarketplace(jwtToken);
      if (data != null) {
        var jsonData = json.decode(data);
        List<Speaker> speakers = List<Speaker>.from(jsonData['response']
            .map((speakerJson) => Speaker.fromJson(speakerJson)));
        
        // Cache fetched data
        _saveDataToCache(speakers);

        return speakers;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<String?> getAllMarketplace(String? jwtToken) async {
    if (jwtToken == null) {
      print('jwtToken is null');
      return null;
    }

    String url =
        'https://api-voice-staging.botnoi.ai/api/service/get_all_marketplace';

    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      } else {
        print(
            'Failed to load Marketplace data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Marketplace data: $e');
      return null;
    }
  }

  Future<List<Speaker>?> _loadDataFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('marketplaceData');
    if (cachedData != null && cachedData.isNotEmpty) {
      var jsonData = json.decode(cachedData);
      return List<Speaker>.from(jsonData.map((x) => Speaker.fromJson(x)));
    }
    return null;
  }

  Future<void> _saveDataToCache(List<Speaker> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = json.encode(data.map((e) => e.toJson()).toList());
    prefs.setString('marketplaceData', jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Speaker>>(
      future: _fetchMarketplaceDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<Speaker> speakers = snapshot.data!;
          speakers.sort((a, b) =>
              int.parse(a.speakerId).compareTo(int.parse(b.speakerId)));

          return ListView.builder(
            itemCount: speakers.length,
            itemBuilder: (context, index) {
              Speaker speaker = speakers[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VoiceScreen(speakerId: speaker.speakerId),
                    ),
                  );
                },
                child: Material(
                  elevation: 2,
                  child: ListTile(
                    leading: Image.network(speaker.faceImage),
                    title: Text(speaker.thaiName),
                    subtitle: Text(speaker.engName),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
