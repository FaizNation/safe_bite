import 'package:safe_bite/features/resep/domain/entities/recipe_detail.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class GetRecipeDetailUseCase {
  final RecipeRepository _repository;

  GetRecipeDetailUseCase(this._repository);

  Future<RecipeDetail> call(String id) async {
    return _repository.getRecipeDetail(id);
  }
}
