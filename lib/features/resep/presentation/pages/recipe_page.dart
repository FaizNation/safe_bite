import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_search_bar.dart';
import 'recipe_detail_page.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        RecipeRepositoryImpl(remoteDataSource: RecipeRemoteDataSourceImpl()),
      )..loadInitialData(),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resep',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          RecipeSearchBar(
            // We need to check exact filename usage
            onChanged: (query) {
              // Debounce could be added here
              if (query.length > 2) {
                context.read<RecipeCubit>().searchRecipes(query);
              } else if (query.isEmpty) {
                context.read<RecipeCubit>().loadInitialData();
              }
            },
            onFilterTap: () {
              // Show filter dialog or bottom sheet
              // For now, let's just trigger a category filter "Dessert" as a demo
              context.read<RecipeCubit>().filterByCategory('Dessert');
            },
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          const Icon(Icons.restaurant, color: Colors.green, size: 30),
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
            color: Colors.grey.withOpacity(0.1),
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
}
