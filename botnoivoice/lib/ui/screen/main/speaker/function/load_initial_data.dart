import 'package:botnoivoice/function/get_jwt_token.dart';
import 'package:botnoivoice/service/favorite/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Future<void> loadInitialData({
  required BuildContext context,
  required Logger logger,
  required Function(List<String>) setSelectedIndexFavorites,
  required Function(bool) setLoading,
}) async {
  try {
    final String? token = await getJwtTokenAll(context);
    if (token == null || token.isEmpty) {
      setLoading(false);
      return;
    }

    final FavoriteService favoriteService = FavoriteService();
    final List<String> fetchedFavorites = await favoriteService.getFavoriteSpeakers(token);

    setSelectedIndexFavorites(fetchedFavorites);
  } catch (e) {
    logger.e("Error loading favorite speakers: $e");
  } finally {
    setLoading(false);
  }
}
