import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_bite/features/stats/domain/repositories/stats_repository.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';
import 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final StatsRepository repository;

  StatsCubit(this.repository) : super(StatsInitial());

  Future<void> loadStats({TimeRange range = TimeRange.bulan}) async {
    try {
      emit(StatsLoading());
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const StatsError("User not logged in"));
        return;
      }

      final items = await repository.getStats(range, user.uid);

      emit(StatsLoaded(items: items, timeRange: range));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  void updateTimeRange(TimeRange range) {
    loadStats(range: range);
  }
}
