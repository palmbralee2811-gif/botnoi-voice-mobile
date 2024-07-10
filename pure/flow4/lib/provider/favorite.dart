import 'package:flow3/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Data>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Data data) {
    final mealIsFavorite = state.contains(data);

    if (mealIsFavorite) {
      state = state.where((m) => m.name != data.name).toList();
      return false;
    } else {
      state = [...state, data];
      return true;
  }
  }
}

final favoriteMealsProvider = 
  StateNotifierProvider<FavoriteMealsNotifier, List<Data>>((ref) {
  return FavoriteMealsNotifier();
});