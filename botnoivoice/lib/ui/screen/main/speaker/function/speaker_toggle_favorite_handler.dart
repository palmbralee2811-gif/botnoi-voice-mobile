import 'package:botnoivoice/function/get_jwt_token.dart';
import 'package:botnoivoice/service/favorite/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<void> handleFavoriteToggle({
  required BuildContext context,
  required Logger logger,
  required String speakerId,
  required List<String> selectedIndexFavorites,
  required Function(List<String>) setSelectedIndexFavorites,
}) async {
  final bool isCurrentlyFavorite = selectedIndexFavorites.contains(speakerId);
  final originalFavorites = List<String>.from(selectedIndexFavorites);

  setSelectedIndexFavorites(
    isCurrentlyFavorite
      ? (List<String>.from(selectedIndexFavorites)..remove(speakerId))
      : (List<String>.from(selectedIndexFavorites)..add(speakerId)),
  );

  logger.d("UI list state is now: $selectedIndexFavorites");

  try {
    final String? token = await getJwtTokenAll(context);
    if (token == null || token.isEmpty) {
      throw Exception('Token not found.');
    }

    final favoriteService = FavoriteService();

    if (isCurrentlyFavorite) {
      logger.i(">>> Calling REMOVE API for ID: $speakerId");
      await favoriteService.removeFavoriteSpeaker(speakerId, token);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorite removed!')),
        );
      }
    } else {
      final listToSend = List<String>.from(selectedIndexFavorites);
      logger.i(">>> Calling SAVE API with list: $listToSend");
      await favoriteService.saveFavoriteSpeakers(listToSend, token);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorite added!')),
        );
      }
    }
  } catch (e) {
    logger.e("Error in favorite toggle API call: $e");
    if (context.mounted) {
      setSelectedIndexFavorites(originalFavorites);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: ${e.toString()}')),
      );
    }
  }
}
