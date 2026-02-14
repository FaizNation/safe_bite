import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_detail.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';
import '../../../../core/utils/translation_helper.dart';

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

    // Translate fields
    // Running in parallel to save time
    final results = await Future.wait([
      translationHelper.translateText(detail.instructions),
      translationHelper.translateText(detail.category),
      translationHelper.translateText(detail.area),
      translationHelper.translateList(detail.ingredients),
      translationHelper.translateText(detail.name), // Translate name
    ]);

    return RecipeDetail(
      id: detail.id,
      name: results[4] as String, // Use translated name
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
    // 1. Translate query from ID to EN
    final translatedQuery = await translationHelper.translateText(
      query,
      to: 'en',
    );

    // 2. Fetch recipes with translated query
    final recipes = await remoteDataSource.searchRecipes(translatedQuery);

    // 3. Translate recipe names from EN to ID
    return _translateRecipes(recipes);
  }

  Future<List<Recipe>> _translateRecipes(List<Recipe> recipes) async {
    if (recipes.isEmpty) return [];

    final names = recipes.map((r) => r.name).toList();
    final translatedNames = await translationHelper.translateList(names);

    // Map back to Recipe objects with translated names
    // maintaining the original order
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
