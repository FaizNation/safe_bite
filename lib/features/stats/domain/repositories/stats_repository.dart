import '../entities/stat_item.dart';

abstract class StatsRepository {
  Future<List<StatItem>> getStats(TimeRange range, String userId);
}
