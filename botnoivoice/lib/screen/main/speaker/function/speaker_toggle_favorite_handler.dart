import 'package:botnoivoice/screen/main/speaker/function/snackbar_favorites.dart';
import 'package:botnoivoice/shared/function/get_jwt_token.dart';
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

  // ทำการ clone และแก้ไข list ใหม่
  final updatedFavorites = isCurrentlyFavorite
      ? (List<String>.from(selectedIndexFavorites)..remove(speakerId))
      : (List<String>.from(selectedIndexFavorites)..add(speakerId));

  // setState ให้ UI
  // เช็กก่อนว่า context ยัง mounted ไหม
  if (context.mounted) {
    setSelectedIndexFavorites(updatedFavorites);
  }

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
      if (!context.mounted) return;
      if (context.mounted) {
        showAddSnackBar(context , 'Favorite removed!');
      }
    } else {
      final listToSend = List<String>.from(updatedFavorites);
      logger.i(">>> Calling SAVE API with list: $listToSend");
      await favoriteService.saveFavoriteSpeakers(listToSend, token);
      if (!context.mounted) return;
      if (context.mounted) {
        showAddSnackBar(context , 'Favorite added!');
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
