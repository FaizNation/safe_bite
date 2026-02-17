import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/usecases/get_random_recipes_usecase.dart';
import 'package:safe_bite/features/resep/domain/usecases/get_recipe_detail_usecase.dart';
import 'package:safe_bite/features/resep/domain/usecases/get_recipes_by_category_usecase.dart';
import 'package:safe_bite/features/resep/domain/usecases/get_recipes_by_ingredient_usecase.dart';
import 'package:safe_bite/features/resep/domain/usecases/search_recipes_usecase.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final SearchRecipesUseCase _searchRecipes;
  final GetRecipesByCategoryUseCase _getRecipesByCategory;
  final GetRecipeDetailUseCase _getRecipeDetail;
  final GetRandomRecipesUseCase _getRandomRecipes;
  final GetRecipesByIngredientUseCase _getRecipesByIngredient;

  RecipeCubit({
    required SearchRecipesUseCase searchRecipes,
    required GetRecipesByCategoryUseCase getRecipesByCategory,
    required GetRecipeDetailUseCase getRecipeDetail,
    required GetRandomRecipesUseCase getRandomRecipes,
    required GetRecipesByIngredientUseCase getRecipesByIngredient,
  }) : _searchRecipes = searchRecipes,
       _getRecipesByCategory = getRecipesByCategory,
       _getRecipeDetail = getRecipeDetail,
       _getRandomRecipes = getRandomRecipes,
       _getRecipesByIngredient = getRecipesByIngredient,
       super(RecipeInitial());

  Future<void> loadInitialData() async {
    try {
      emit(RecipeLoading());

      final recipes = await _getRecipesByCategory('Breakfast');
      final recommendations = await _getRecipesByCategory('Dessert');

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
      final results = await _searchRecipes(query);
      final recommendations = await _getRandomRecipes();

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
      final recipes = await _getRecipesByCategory(category);

      if (currentRecommendations.isEmpty) {
        currentRecommendations = await _getRandomRecipes();
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
      final recipes = await _getRecipesByIngredient(ingredient);

      if (currentRecommendations.isEmpty) {
        currentRecommendations = await _getRandomRecipes();
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
      final detail = await _getRecipeDetail(id);
      emit(RecipeDetailLoaded(detail));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
