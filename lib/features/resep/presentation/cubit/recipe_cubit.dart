import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository repository;

  RecipeCubit(this.repository) : super(RecipeInitial());

  Future<void> loadInitialData() async {
    try {
      emit(RecipeLoading());

      final recipes = await repository.getRecipesByCategory('Breakfast');
      final recommendations = await repository.getRecipesByCategory('Dessert');

      emit(
        RecipeLoaded(
          recipes: recipes,
          recommendations: recommendations,
          activeCategory: 'Breakfast',
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> searchRecipes(String query) async {
    try {
      emit(RecipeLoading());
      final results = await repository.searchRecipes(query);
      final recommendations = await repository.getRandomRecipes();

      emit(
        RecipeLoaded(
          recipes: results,
          recommendations: recommendations,
          activeCategory: 'Search: $query',
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    try {
      List<Recipe> currentRecommendations = [];
      if (state is RecipeLoaded) {
        currentRecommendations = (state as RecipeLoaded).recommendations;
      }

      emit(RecipeLoading());
      final recipes = await repository.getRecipesByCategory(category);

      if (currentRecommendations.isEmpty) {
        currentRecommendations = await repository.getRandomRecipes();
      }

      emit(
        RecipeLoaded(
          recipes: recipes,
          recommendations: currentRecommendations,
          activeCategory: category,
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> filterByIngredient(String ingredient) async {
    try {
      List<Recipe> currentRecommendations = [];
      if (state is RecipeLoaded) {
        currentRecommendations = (state as RecipeLoaded).recommendations;
      }

      emit(RecipeLoading());
      final recipes = await repository.getRecipesByIngredient(ingredient);

      if (currentRecommendations.isEmpty) {
        currentRecommendations = await repository.getRandomRecipes();
      }

      emit(
        RecipeLoaded(
          recipes: recipes,
          recommendations: currentRecommendations,
          activeCategory: 'Ingredient: $ingredient',
        ),
      );
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> loadRecipeDetail(String id) async {
    try {
      emit(RecipeDetailLoading());
      final detail = await repository.getRecipeDetail(id);
      emit(RecipeDetailLoaded(detail));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
