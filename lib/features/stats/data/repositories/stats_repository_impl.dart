import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'package:safe_bite/features/stats/domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final FirebaseFirestore firestore;

  StatsRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<StatItem>> getStats(TimeRange range, String userId) async {
    final now = DateTime.now();
    DateTime startDate;

    switch (range) {
      case TimeRange.hari:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case TimeRange.minggu:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.bulan:
        startDate = now.subtract(const Duration(days: 30));
        break;
    }

    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('food_items') 
          .where(
            'added_at',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .get();

      final docs = querySnapshot.docs;
      if (docs.isEmpty) return [];

      final Map<String, int> categoryCounts = {};
      int totalItems = 0;

      for (var doc in docs) {
        final data = doc.data();
        final rawCategory = data['category'] as String? ?? 'Other';
        final category = _mapCategoryToIndonesian(rawCategory);

        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        totalItems++;
      }

      final List<StatItem> items = [];

      categoryCounts.forEach((category, count) {
        final percentage = (count / totalItems) * 100;
        items.add(
          StatItem(
            category: category,
            count: count,
            percentage: percentage,
            color: _getColorForCategory(category),
          ),
        );
      });

      items.sort((a, b) => b.percentage.compareTo(a.percentage));

      return items;
    } catch (e) {
      debugPrint("Error fetching stats: $e");
      return [];
    }
  }

  String _mapCategoryToIndonesian(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('vegetable') || lower.contains('sayur')) return 'Sayur';
    if (lower.contains('fruit') || lower.contains('buah')) return 'Buah';
    if (lower.contains('meat') ||
        lower.contains('daging') ||
        lower.contains('chicken') ||
        lower.contains('ayam') ||
        lower.contains('fish') ||
        lower.contains('ikan')) {
      return 'Daging';
    }
    if (lower.contains('milk') ||
        lower.contains('dairy') ||
        lower.contains('susu')) {
      return 'Susu';
    }
    return 'Lainnya';
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Sayur':
        return const Color(0xFF2E7D32); 
      case 'Buah':
        return const Color(0xFF8BC34A); 
      case 'Daging':
        return const Color(0xFFD32F2F); 
      case 'Susu':
        return const Color(0xFFFFC107); 
      default:
        return const Color(0xFF9E9E9E); 
    }
  }
}
