import 'dart:convert';
import '../../domain/entities/food_analysis.dart';

class FoodAnalysisModel extends FoodAnalysis {
  const FoodAnalysisModel({
    required super.isFood,
    required super.foodName,
    required super.category,
    required super.freshnessLevel,
    required super.shelfLife,
    required super.storageAdvice,
    required super.caloriesApprox,
    required super.recipeIdea,
  });

  factory FoodAnalysisModel.fromJson(String jsonString) {
    // Crucial: Handle potential markdown formatting (remove ```json and ```) before decoding.
    String cleanJson = jsonString
        .replaceAll(RegExp(r'^```json\s*'), '')
        .replaceAll(RegExp(r'\s*```$'), '');

    final Map<String, dynamic> json = jsonDecode(cleanJson);

    return FoodAnalysisModel(
      isFood: json['is_food'] ?? false,
      foodName: json['food_name'] ?? 'Unknown',
      category: json['category'] ?? 'Unknown',
      freshnessLevel: json['freshness_level'] ?? 'Unknown',
      shelfLife: json['shelf_life'] ?? 'Unknown',
      storageAdvice: json['storage_advice'] ?? 'Unknown',
      caloriesApprox: json['calories_approx'] ?? 0,
      recipeIdea: json['recipe_idea'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_food': isFood,
      'food_name': foodName,
      'category': category,
      'freshness_level': freshnessLevel,
      'shelf_life': shelfLife,
      'storage_advice': storageAdvice,
      'calories_approx': caloriesApprox,
      'recipe_idea': recipeIdea,
    };
  }
}
