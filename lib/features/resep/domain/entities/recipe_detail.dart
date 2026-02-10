import 'recipe.dart';

class RecipeDetail extends Recipe {
  final String instructions;
  final List<String> ingredients;
  final List<String> measures;
  final String? youtubeUrl;
  final String area;

  const RecipeDetail({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.category,
    required this.instructions,
    required this.ingredients,
    required this.measures,
    this.youtubeUrl,
    required this.area,
    super.timeMinutes,
    super.rating,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    instructions,
    ingredients,
    measures,
    youtubeUrl,
    area,
  ];
}
