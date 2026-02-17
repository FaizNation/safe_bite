import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';

abstract class StatsRemoteDataSource {
  Future<List<StatItem>> getStats(DateTime startDate, String userId);
}
