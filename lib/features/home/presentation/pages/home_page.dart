import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/home/presentation/widgets/category_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/expiring_items_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/home_header.dart';
import 'package:safe_bite/features/home/presentation/widgets/stats_card.dart';

import '../../data/repositories/home_repository_impl.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeRepositoryImpl())..loadHomeData(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/stats_top.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().loadHomeData();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF558B49),
                        ),
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is HomeLoaded) {
                      // Filter items based on category
                      final filteredItems = state.selectedCategory == 'all'
                          ? state.expiringItems
                          : state.expiringItems.where((item) {
                              final category = item.category.toLowerCase();
                              final selected = state.selectedCategory
                                  .toLowerCase();

                              if (selected == 'vegetables') {
                                return category.contains('vegetable') ||
                                    category.contains('sayur');
                              }
                              if (selected == 'fruits') {
                                return category.contains('fruit') ||
                                    category.contains('buah');
                              }
                              if (selected == 'meat') {
                                return category.contains('meat') ||
                                    category.contains('daging') ||
                                    category.contains('chicken') ||
                                    category.contains('ayam') ||
                                    category.contains('fish') ||
                                    category.contains('ikan');
                              }
                              if (selected == 'milk') {
                                return category.contains('milk') ||
                                    category.contains('susu') ||
                                    category.contains('dairy');
                              }

                              return category == selected;
                            }).toList();

                      // Calculate stats (based on all items or filtered? usually all for stats)
                      final expiringCount = state.expiringItems
                          .where(
                            (item) =>
                                _calculateDaysUntilExpiry(item.expiryDate) <= 3,
                          )
                          .length;
                      final savedCount = state.expiringItems.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(user: state.user),
                          const SizedBox(height: 24),
                          StatsCard(
                            expiringCount: expiringCount,
                            savedCount: savedCount,
                          ),
                          const SizedBox(height: 24),
                          CategoryList(
                            selectedCategory: state.selectedCategory,
                            onCategorySelected: (category) {
                              context.read<HomeCubit>().selectCategory(
                                category,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Daftar Bahan Mendekati Kadaluwarsa',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ExpiringItemsList(items: filteredItems),
                          const SizedBox(height: 80),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysUntilExpiry(DateTime? expiryDate) {
    if (expiryDate == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }
}
