import '../entities/recipe.dart';
import '../entities/recipe_detail.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<Recipe>> getRecipesByCategory(String category);
  Future<RecipeDetail> getRecipeDetail(String id);
  Future<List<Recipe>> getRandomRecipes();
  Future<List<Recipe>> getRecipesByIngredient(String ingredient);
}
