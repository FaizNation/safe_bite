import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/stat_item.dart';

class DonutChartWidget extends StatelessWidget {
  final List<StatItem> items;

  const DonutChartWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("Belum ada data")),
      );
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              startDegreeOffset: -90,
              sections: items.map((item) {
                return PieChartSectionData(
                  color: item.color,
                  value: item.percentage,
                  title: '${item.percentage.toStringAsFixed(0)}%',
                  radius: 30, // Thickness
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
          // Optional center text or empty
        ],
      ),
    );
  }
}
