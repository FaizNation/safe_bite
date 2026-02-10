import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/home/presentation/widgets/category_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/expiring_items_list.dart';
import 'package:safe_bite/features/home/presentation/widgets/home_header.dart';
import 'package:safe_bite/features/home/presentation/widgets/stats_card.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';


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
      body: SafeArea(
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
                    child: CircularProgressIndicator(color: Color(0xFF558B49)),
                  );
                } else if (state is HomeError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is HomeLoaded) {
                  // Calculate stats
                  final expiringCount = state.expiringItems
                      .where(
                        (item) =>
                            (item.expiryDate
                                    ?.difference(DateTime.now())
                                    .inDays ??
                                7) <=
                            3,
                      )
                      .length;
                  final savedCount = state
                      .expiringItems
                      .length; 

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
                      const CategoryList(),
                      const SizedBox(height: 24),
                      const Text(
                        'Daftar Bahan Mendekati Kadaluwarsa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ExpiringItemsList(items: state.expiringItems),
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
    );
  }
}
