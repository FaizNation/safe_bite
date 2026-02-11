import 'dart:ui';
import 'package:equatable/equatable.dart';

class StatItem extends Equatable {
  final String category;
  final int count;
  final double percentage;
  final Color color;

  const StatItem({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  List<Object?> get props => [category, count, percentage, color];
}

enum TimeRange { hari, minggu, bulan }
