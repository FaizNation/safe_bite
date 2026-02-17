import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class SearchRecipesUseCase {
  final RecipeRepository _repository;

  SearchRecipesUseCase(this._repository);

  Future<List<Recipe>> call(String query) async {
    return _repository.searchRecipes(query);
  }
}
