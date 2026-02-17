import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/home/presentation/cubit/home_cubit.dart';
import 'package:safe_bite/features/home/presentation/cubit/home_state.dart';
import 'package:safe_bite/features/home/presentation/widgets/category_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/expiring_items_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/home_header.dart';
import 'package:safe_bite/features/home/presentation/widgets/stats_card.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_state.dart';
import 'package:safe_bite/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:safe_bite/features/scan/presentation/cubit/scan_state.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              context.read<HomeCubit>().loadHomeData();
            }
          },
        ),
        BlocListener<ScanCubit, ScanState>(
          listener: (context, state) {
            if (state is ScanSaved) {
              context.read<HomeCubit>().loadHomeData();
            }
          },
        ),
      ],
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/stats_top.png',
              fit: BoxFit.cover,
            ),
          ),

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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeHeader(user: state.user),
                          const SizedBox(height: 24),
                          StatsCard(
                            expiringCount: state.expiringCount,
                            savedCount: state.savedCount,
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
                          ExpiringItemsList(items: state.filteredItems),
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
}