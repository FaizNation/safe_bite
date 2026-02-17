import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'package:safe_bite/features/stats/domain/usecases/get_stats_usecase.dart';
import 'package:safe_bite/features/stats/presentation/cubit/stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final GetStatsUseCase _getStats;
  final GetCurrentUserUseCase _getCurrentUser;

  StatsCubit({
    required GetStatsUseCase getStats,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _getStats = getStats,
        _getCurrentUser = getCurrentUser,
        super(StatsInitial());

  Future<void> loadStats({TimeRange range = TimeRange.bulan}) async {
    try {
      emit(StatsLoading());
      final user = await _getCurrentUser();

      if (user == null) {
        emit(const StatsError('User not logged in'));
        return;
      }

      final items = await _getStats(range: range, userId: user.uid);

      emit(StatsLoaded(items: items, timeRange: range));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  void updateTimeRange(TimeRange range) {
    loadStats(range: range);
  }
}
