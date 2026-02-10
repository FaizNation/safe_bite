import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_detail.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.category,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbUrl: json['strMealThumb'] as String,
      category: json['strCategory'] ?? 'Unknown',
    );
  }
}

class RecipeDetailModel extends RecipeDetail {
  const RecipeDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.category,
    required super.instructions,
    required super.ingredients,
    required super.measures,
    super.youtubeUrl,
    required super.area,
  });

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return RecipeDetailModel(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbUrl: json['strMealThumb'] as String,
      category: json['strCategory'] as String,
      instructions: json['strInstructions'] as String,
      ingredients: ingredients,
      measures: measures,
      youtubeUrl: json['strYoutube'] as String?,
      area: json['strArea'] as String,
    );
  }
}
