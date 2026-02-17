import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/core/utils/category_helper.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'stats_remote_datasource.dart';

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final FirebaseFirestore _firestore;

  StatsRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<StatItem>> getStats(DateTime startDate, String userId) async {
    try {
      final querySnapshot = await _firestore
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
        final category = _toLabelFromKey(normalizeCategory(rawCategory));

        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        totalItems++;
      }

      final List<StatItem> items = [];

      // ignore: avoid_types_as_parameter_names
      categoryCounts.forEach((category, count) {
        final percentage = (count / totalItems) * 100;
        items.add(
          StatItem(category: category, count: count, percentage: percentage),
        );
      });

      items.sort((a, b) => b.percentage.compareTo(a.percentage));

      return items;
    } catch (e) {
      AppLogger.error('Error fetching stats: $e');
      return [];
    }
  }

  String _toLabelFromKey(String key) {
    switch (key) {
      case 'vegetables':
        return 'Sayur';
      case 'fruits':
        return 'Buah';
      case 'meat':
        return 'Daging';
      case 'milk':
        return 'Susu';
      default:
        return 'Lainnya';
    }
  }
}
