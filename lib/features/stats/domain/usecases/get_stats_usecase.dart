import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'package:safe_bite/features/stats/domain/repositories/stats_repository.dart';

class GetStatsUseCase {
  final StatsRepository _repository;

  const GetStatsUseCase(this._repository);

  Future<List<StatItem>> call({
    required TimeRange range,
    required String userId,
  }) {
    return _repository.getStats(range, userId);
  }
}
