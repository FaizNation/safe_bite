import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class GetRandomRecipesUseCase {
  final RecipeRepository _repository;

  GetRandomRecipesUseCase(this._repository);

  Future<List<Recipe>> call() async {
    return _repository.getRandomRecipes();
  }
}
