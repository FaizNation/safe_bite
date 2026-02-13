import 'package:equatable/equatable.dart';
import 'package:safe_bite/features/stats/domain/entities/stat_item.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final List<StatItem> items;
  final TimeRange timeRange;

  const StatsLoaded({required this.items, required this.timeRange});

  @override
  List<Object?> get props => [items, timeRange];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
