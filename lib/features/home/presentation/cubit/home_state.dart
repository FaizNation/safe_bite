import 'package:equatable/equatable.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserEntity? user;
  final List<FoodItem> expiringItems;

  const HomeLoaded({this.user, required this.expiringItems});

  @override
  List<Object?> get props => [user, expiringItems];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
