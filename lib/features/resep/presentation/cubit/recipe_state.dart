import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_detail.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final List<Recipe> recommendations;
  final String activeCategory;

  const RecipeLoaded({
    this.recipes = const [],
    this.recommendations = const [],
    this.activeCategory = 'Breakfast',
  });

  @override
  List<Object?> get props => [recipes, recommendations, activeCategory];

  RecipeLoaded copyWith({
    List<Recipe>? recipes,
    List<Recipe>? recommendations,
    String? activeCategory,
  }) {
    return RecipeLoaded(
      recipes: recipes ?? this.recipes,
      recommendations: recommendations ?? this.recommendations,
      activeCategory: activeCategory ?? this.activeCategory,
    );
  }
}

class RecipeDetailLoading extends RecipeState {}

class RecipeDetailLoaded extends RecipeState {
  final RecipeDetail recipe;

  const RecipeDetailLoaded(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}
