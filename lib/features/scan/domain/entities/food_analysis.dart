import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String foodName;
  final String category;
  final String freshnessLevel;
  final String shelfLife;
  final String storageAdvice;
  final int caloriesApprox;
  final String recipeIdea;
  final int quantity;
  final List<int>? boundingBox;
  final DateTime? expiryDate;
  final String? imageUrl;

  const FoodItem({
    required this.foodName,
    required this.category,
    required this.freshnessLevel,
    required this.shelfLife,
    required this.storageAdvice,
    required this.caloriesApprox,
    required this.recipeIdea,
    this.quantity = 1,
    this.boundingBox,
    this.expiryDate,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    foodName,
    category,
    freshnessLevel,
    shelfLife,
    storageAdvice,
    caloriesApprox,
    recipeIdea,
    boundingBox,
    expiryDate,
    imageUrl,
  ];
}

class FoodAnalysis extends Equatable {
  final bool isFood;
  final List<FoodItem> items;

  const FoodAnalysis({required this.isFood, required this.items});

  @override
  List<Object?> get props => [isFood, items];
}
