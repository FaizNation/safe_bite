import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';

abstract class StatsRepository {
  Future<List<StatItem>> getStats(TimeRange range, String userId);
}
