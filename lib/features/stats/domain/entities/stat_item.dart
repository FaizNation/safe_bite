import 'package:equatable/equatable.dart';

class StatItem extends Equatable {
  final String category;
  final int count;
  final double percentage;

  const StatItem({
    required this.category,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [category, count, percentage];
}

enum TimeRange { hari, minggu, bulan }
