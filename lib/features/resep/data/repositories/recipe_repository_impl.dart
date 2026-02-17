import 'package:safe_bite/core/utils/translation_helper.dart';
import 'package:safe_bite/features/resep/data/datasources/recipe_remote_datasource.dart';
import 'package:safe_bite/features/resep/domain/entities/recipe.dart';
import 'package:safe_bite/features/resep/domain/entities/recipe_detail.dart';
import 'package:safe_bite/features/resep/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final TranslationHelper translationHelper;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    TranslationHelper? translationHelper,
  }) : translationHelper = translationHelper ?? TranslationHelper();

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final recipes = await remoteDataSource.getRecipesByCategory(category);
    return _translateRecipes(recipes);
  }

  @override
  Future<List<Recipe>> getRandomRecipes() async {
    final recipes = await remoteDataSource.getRandomRecipes();
    return _translateRecipes(recipes);
  }

  @override
  Future<RecipeDetail> getRecipeDetail(String id) async {
    final detail = await remoteDataSource.getRecipeDetail(id);

    final results = await Future.wait([
      translationHelper.translateText(detail.instructions),
      translationHelper.translateText(detail.category),
      translationHelper.translateText(detail.area),
      translationHelper.translateList(detail.ingredients),
      translationHelper.translateText(detail.name),
    ]);

    return RecipeDetail(
      id: detail.id,
      name: results[4] as String,
      thumbUrl: detail.thumbUrl,
      category: results[1] as String,
      instructions: results[0] as String,
      ingredients: results[3] as List<String>,
      measures: detail.measures,
      youtubeUrl: detail.youtubeUrl,
      area: results[2] as String,
    );
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    final translatedQuery = await translationHelper.translateText(
      query,
      to: 'en',
    );

    final recipes = await remoteDataSource.searchRecipes(translatedQuery);

    return _translateRecipes(recipes);
  }

  @override
  Future<List<Recipe>> getRecipesByIngredient(String ingredient) async {
    final translatedIngredient = await translationHelper.translateText(
      ingredient,
      to: 'en',
    );

    final recipes = await remoteDataSource.getRecipesByIngredient(
      translatedIngredient,
    );
    return _translateRecipes(recipes);
  }

  Future<List<Recipe>> _translateRecipes(List<Recipe> recipes) async {
    if (recipes.isEmpty) return [];

    final names = recipes.map((r) => r.name).toList();
    final translatedNames = await translationHelper.translateList(names);

    return List.generate(recipes.length, (index) {
      final recipe = recipes[index];
      return Recipe(
        id: recipe.id,
        name: translatedNames[index],
        thumbUrl: recipe.thumbUrl,
        category: recipe.category,
      );
    });
  }
}
