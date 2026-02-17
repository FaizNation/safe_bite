import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/usecases/search_recipes_usecase.dart';
import '../../domain/usecases/get_recipes_by_category_usecase.dart';
import '../../domain/usecases/get_recipe_detail_usecase.dart';
import '../../domain/usecases/get_random_recipes_usecase.dart';
import '../../domain/usecases/get_recipes_by_ingredient_usecase.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_search_bar.dart';
import 'recipe_detail_page.dart';

RecipeCubit _createRecipeCubit() {
  final datasource = RecipeRemoteDataSourceImpl();
  final repository = RecipeRepositoryImpl(remoteDataSource: datasource);
  return RecipeCubit(
    searchRecipes: SearchRecipesUseCase(repository),
    getRecipesByCategory: GetRecipesByCategoryUseCase(repository),
    getRecipeDetail: GetRecipeDetailUseCase(repository),
    getRandomRecipes: GetRandomRecipesUseCase(repository),
    getRecipesByIngredient: GetRecipesByIngredientUseCase(repository),
  );
}

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createRecipeCubit()..loadInitialData(),
      child: const RecipeView(),
    );
  }
}

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(context),

            // Content
            Expanded(
              child: BlocBuilder<RecipeCubit, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF558B49),
                      ),
                    );
                  } else if (state is RecipeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is RecipeLoaded) {
                    return _buildContent(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 130,
          left: 0,
          right: 0,
          child: Image.asset('assets/images/resep_top.png', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(
                    0xFFE8F5E9,
                  ).withValues(alpha: 0.8), 
                  Colors.white.withValues(alpha: 0.0), 
                  Colors.white, 
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Content
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ), 
              const Text(
                'Resep',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E1E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mau masak apa hari ini?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 70,
              ), 
              // Search Bar
              RecipeSearchBar(
                onChanged: (query) {
                  if (query.length > 2) {
                    context.read<RecipeCubit>().searchRecipes(query);
                  } else if (query.isEmpty) {
                    context.read<RecipeCubit>().loadInitialData();
                  }
                },
                onFilterTap: () {
                  _showFilterDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, RecipeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecipeCubit>().loadInitialData();
      },
      color: const Color(0xFF558B49),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        children: [
          _buildBanner(),
          const SizedBox(height: 24),

          ...state.recipes.map(
            (recipe) => RecipeCard(
              recipe: recipe,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(recipeId: recipe.id),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Rekomendasi Resep Lainnya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final recipe = state.recommendations[index];
                return _buildRecommendationCard(context, recipe);
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 90, 
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Stack(
        children: [
          // Left Image
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/banner_resep_kiri.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Right Image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/banner_resep_kanan.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bahan mendekati basi?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Saatnya jadi menu spesial!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, dynamic recipe) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              recipe.thumbUrl,
              height: 100,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${recipe.timeMinutes} menit',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final cubit = context.read<RecipeCubit>();

    showDialog(
      context: context,
      builder: (modalContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Berdasarkan Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFilterChip(modalContext, 'Sayur', Icons.grass, () {
                      cubit.filterByCategory('Vegetarian');
                      Navigator.pop(modalContext);
                    }),
                    _buildFilterChip(
                      modalContext,
                      'Daging',
                      Icons.restaurant,
                      () {
                        cubit.filterByCategory('Beef');
                        Navigator.pop(modalContext);
                      },
                    ),
                    _buildFilterChip(
                      modalContext,
                      'Buah',
                      Icons.local_florist,
                      () {
                        cubit.filterByCategory('Dessert');
                        Navigator.pop(modalContext);
                      },
                    ),
                    _buildFilterChip(
                      modalContext,
                      'Susu',
                      Icons.local_drink,
                      () {
                        cubit.filterByIngredient('Milk');
                        Navigator.pop(modalContext);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
