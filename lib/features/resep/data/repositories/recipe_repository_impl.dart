import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_detail.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    return await remoteDataSource.getRecipesByCategory(category);
  }

  @override
  Future<List<Recipe>> getRandomRecipes() async {
    return await remoteDataSource.getRandomRecipes();
  }

  @override
  Future<RecipeDetail> getRecipeDetail(String id) async {
    return await remoteDataSource.getRecipeDetail(id);
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    return await remoteDataSource.searchRecipes(query);
  }
}
