import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class GetRecipesByIngredientUseCase {
  final RecipeRepository _repository;

  GetRecipesByIngredientUseCase(this._repository);

  Future<List<Recipe>> call(String ingredient) async {
    return _repository.getRecipesByIngredient(ingredient);
  }
}
