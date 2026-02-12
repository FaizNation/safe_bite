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
        height: 250,
        child: Center(
          child: Text(
            "Belum ada data",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: items.map((item) {
                return PieChartSectionData(
                  color: item.color,
                  value: item.percentage,
                  title: '${item.percentage.toStringAsFixed(0)}%',
                  radius: 40, // Thickness
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
