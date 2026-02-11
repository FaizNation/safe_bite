import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/stat_item.dart';
import '../../domain/repositories/stats_repository.dart';

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
          .collection('scans')
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
        final category = data['category'] as String? ?? 'Lainnya';
        // Normalize category string if needed
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

  Color _getColorForCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('sayur')) return const Color(0xFF43A047);
    if (lower.contains('buah')) return const Color(0xFF8BC34A);
    if (lower.contains('daging') ||
        lower.contains('ayam') ||
        lower.contains('ikan')) {
      return const Color(0xFFD32F2F);
    }
    if (lower.contains('susu') || lower.contains('dairy'))
      return const Color(0xFFFBC02D); // Yellow
    if (lower.contains('roti') || lower.contains('snack'))
      return const Color(0xFFFFA000); // Orange

    return Colors.grey; // Default
  }
}
