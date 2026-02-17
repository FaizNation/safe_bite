import 'package:safe_bite/features/stats/data/datasources/stats_remote_datasource.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'package:safe_bite/features/stats/domain/repositories/stats_repository.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource _remoteDataSource;

  StatsRepositoryImpl({required StatsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<StatItem>> getStats(TimeRange range, String userId) {
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

    return _remoteDataSource.getStats(startDate, userId);
  }
}
