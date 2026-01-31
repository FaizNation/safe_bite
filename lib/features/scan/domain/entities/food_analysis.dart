import 'package:equatable/equatable.dart';

class FoodAnalysis extends Equatable {
  final bool isFood;
  final String foodName;
  final String category;
  final String freshnessLevel;
  final String shelfLife;
  final String storageAdvice;
  final int caloriesApprox;
  final String recipeIdea;

  const FoodAnalysis({
    required this.isFood,
    required this.foodName,
    required this.category,
    required this.freshnessLevel,
    required this.shelfLife,
    required this.storageAdvice,
    required this.caloriesApprox,
    required this.recipeIdea,
  });

  @override
  List<Object?> get props => [
    isFood,
    foodName,
    category,
    freshnessLevel,
    shelfLife,
    storageAdvice,
    caloriesApprox,
    recipeIdea,
  ];
}
