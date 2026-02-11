import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/entities/stat_item.dart';
import '../cubit/stats_cubit.dart';
import '../cubit/stats_state.dart';
import '../widgets/donut_chart_widget.dart';
import '../widgets/stats_legend_widget.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsCubit(StatsRepositoryImpl())..loadStats(),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User'; // Adjust generic name

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Hai, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pantau jumlah bahan yang kamu selamatkan setiap bulan',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              // Time Toggle
              BlocBuilder<StatsCubit, StatsState>(
                builder: (context, state) {
                  TimeRange currentRange = TimeRange.bulan;
                  if (state is StatsLoaded) {
                    currentRange = state.timeRange;
                  }
                  return _buildTimeToggle(context, currentRange);
                },
              ),
              const SizedBox(height: 32),

              // Chart Area
              BlocBuilder<StatsCubit, StatsState>(
                builder: (context, state) {
                  if (state is StatsLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF558B49),
                        ),
                      ),
                    );
                  } else if (state is StatsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is StatsLoaded) {
                    return Column(
                      children: [
                        DonutChartWidget(items: state.items),
                        const SizedBox(height: 32),
                        StatsLegendWidget(items: state.items),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 30), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeToggle(BuildContext context, TimeRange currentRange) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Background of the toggle container
        borderRadius: BorderRadius.circular(12),
        // Add shadow if needed to look like "elevated" container
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildToggleOption(context, 'Bulan', TimeRange.bulan, currentRange),
          _buildToggleOption(context, 'Minggu', TimeRange.minggu, currentRange),
          _buildToggleOption(context, 'Hari', TimeRange.hari, currentRange),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    BuildContext context,
    String label,
    TimeRange range,
    TimeRange currentRange,
  ) {
    final isSelected = range == currentRange;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<StatsCubit>().updateTimeRange(range);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF558B49) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
