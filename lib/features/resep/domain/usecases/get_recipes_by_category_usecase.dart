import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class GetRecipesByCategoryUseCase {
  final RecipeRepository _repository;

  GetRecipesByCategoryUseCase(this._repository);

  Future<List<Recipe>> call(String category) async {
    return _repository.getRecipesByCategory(category);
  }
}
