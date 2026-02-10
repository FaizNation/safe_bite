import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/recipe_remote_datasource.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        RecipeRepositoryImpl(remoteDataSource: RecipeRemoteDataSourceImpl()),
      )..loadRecipeDetail(recipeId),
      child: const RecipeDetailView(),
    );
  }
}

class RecipeDetailView extends StatelessWidget {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          BlocBuilder<RecipeCubit, RecipeState>(
            builder: (context, state) {
              String? thumbUrl;
              String title = "";

              if (state is RecipeDetailLoaded) {
                thumbUrl = state.recipe.thumbUrl;
                title = state.recipe.name;
              }

              return SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black, // Visible on scroll?
                      // SliverAppBar title color logic is tricky with image
                      // Let's keep it simple or make it invisible initially
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.white, blurRadius: 2)],
                    ),
                  ),
                  background: thumbUrl != null
                      ? CachedNetworkImage(
                          imageUrl: thumbUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey.shade200),
                ),
              );
            },
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<RecipeCubit, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeDetailLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF558B49),
                      ),
                    );
                  } else if (state is RecipeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is RecipeDetailLoaded) {
                    final recipe = state.recipe;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category & Area
                        Row(
                          children: [
                            Chip(
                              label: Text(recipe.category),
                              backgroundColor: const Color(0xFFE8F5E9),
                              labelStyle: const TextStyle(
                                color: Color(0xFF2E7d32),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(recipe.area),
                              backgroundColor: Colors.grey.shade100,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Ingredients Title
                        const Text(
                          "Bahan-bahan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Ingredients List
                        ...List.generate(recipe.ingredients.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Color(0xFF558B49),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${recipe.ingredients[index]} - ${recipe.measures[index]}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // Instructions Title
                        const Text(
                          "Cara Membuat",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Instructions Text
                        Text(
                          recipe.instructions,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),

                        if (recipe.youtubeUrl != null &&
                            recipe.youtubeUrl!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Add url launcher logic later
                              },
                              icon: const Icon(
                                Icons.play_circle_fill,
                                color: Colors.red,
                              ),
                              label: const Text(
                                "Tonton Video Tutorial",
                                style: TextStyle(color: Colors.red),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
