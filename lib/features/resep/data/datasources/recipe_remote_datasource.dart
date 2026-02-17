import 'package:dio/dio.dart';
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/resep/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<List<RecipeModel>> getRecipesByCategory(String category);
  Future<RecipeDetailModel> getRecipeDetail(String id);
  Future<List<RecipeModel>> getRandomRecipes();
  Future<List<RecipeModel>> getRecipesByIngredient(String ingredient);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio client;

  RecipeRemoteDataSourceImpl({Dio? dio}) : client = dio ?? Dio();

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await client.get(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
      );
      final List? meals = response.data['meals'];
      if (meals == null) return [];
      return meals.map((json) => RecipeModel.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Error searching recipes: $e');
      throw Exception('Failed to search recipes');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    try {
      final response = await client.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      );
      final List? meals = response.data['meals'];
      if (meals == null) return [];
      return meals.map((json) {
        final modJson = Map<String, dynamic>.from(json);
        modJson['strCategory'] = category;
        return RecipeModel.fromJson(modJson);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting recipes by category: $e');
      throw Exception('Failed to get recipes by category');
    }
  }

  @override
  Future<RecipeDetailModel> getRecipeDetail(String id) async {
    try {
      final response = await client.get(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id',
      );
      final List? meals = response.data['meals'];
      if (meals == null || meals.isEmpty) throw Exception('Recipe not found');
      return RecipeDetailModel.fromJson(meals.first);
    } catch (e) {
      AppLogger.error('Error getting recipe detail: $e');
      throw Exception('Failed to get recipe detail');
    }
  }

  @override
  Future<List<RecipeModel>> getRandomRecipes() async {
    return getRecipesByCategory('Breakfast');
  }

  @override
  Future<List<RecipeModel>> getRecipesByIngredient(String ingredient) async {
    try {
      final response = await client.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=$ingredient',
      );
      final List? meals = response.data['meals'];
      if (meals == null) return [];
      return meals.map((json) {
        final modJson = Map<String, dynamic>.from(json);
      
        modJson['strCategory'] = 'Unknown';
        return RecipeModel.fromJson(modJson);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting recipes by ingredient: $e');
      throw Exception('Failed to get recipes by ingredient');
    }
  }
}
