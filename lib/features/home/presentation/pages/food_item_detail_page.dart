import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:safe_bite/features/resep/data/datasources/recipe_remote_datasource.dart';
import 'package:safe_bite/features/resep/data/repositories/recipe_repository_impl.dart';
import 'package:safe_bite/features/resep/presentation/cubit/recipe_cubit.dart';
import 'package:safe_bite/features/resep/presentation/cubit/recipe_state.dart';
import 'package:safe_bite/features/home/presentation/widgets/detail_row.dart';
import 'package:safe_bite/features/home/presentation/widgets/recommendation_card.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class FoodItemDetailPage extends StatelessWidget {
  final FoodItem item;

  const FoodItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        RecipeRepositoryImpl(remoteDataSource: RecipeRemoteDataSourceImpl()),
      )..filterByIngredient(item.foodName),
      child: FoodItemDetailView(item: item),
    );
  }
}

class FoodItemDetailView extends StatelessWidget {
  final FoodItem item;

  const FoodItemDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF558B49),
            
            flexibleSpace: FlexibleSpaceBar(
              background: item.imageBlob != null
                  ? Image.memory(
                      item.imageBlob!,
                      fit: BoxFit.cover,
                    )
                  : (item.imageUrl != null
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.fastfood,
                            size: 80,
                            color: Colors.grey,
                          ),
                        )),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF558B49),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.foodName,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF558B49).withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.category,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF558B49),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DetailRow(
                    icon: Icons.calendar_today,
                    label: 'Added At',
                    value: item.addedAt != null
                        ? DateFormat('dd MMM yyyy').format(item.addedAt!)
                        : 'Unknown',
                  ),
                  DetailRow(
                    icon: Icons.local_fire_department,
                    label: 'Calories',
                    value: '${item.caloriesApprox} kcal',
                  ),
                  DetailRow(
                    icon: Icons.shopping_basket,
                    label: 'Quantity',
                    value: '${item.quantity} pcs',
                  ),
                  DetailRow(
                    icon: Icons.timelapse,
                    label: 'Shelf Life',
                    value: item.shelfLife,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Freshness Level',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.freshnessLevel,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Storage Advices',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.storageAdvice,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Rekomendasi Resep',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<RecipeCubit, RecipeState>(
                    builder: (context, state) {
                      if (state is RecipeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF558B49),
                          ),
                        );
                      } else if (state is RecipeError) {
                        return Center(
                          child: Text(
                            'Failed to load recipes',
                            style: GoogleFonts.poppins(color: Colors.red),
                          ),
                        );
                      } else if (state is RecipeLoaded) {
                        if (state.recipes.isEmpty) {
                          return Center(
                            child: Text(
                              'No recipes found for ${item.foodName}',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 180,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.recipes.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final recipe = state.recipes[index];
                              return RecommendationCard(recipe: recipe);
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
