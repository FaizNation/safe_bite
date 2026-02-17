import 'package:equatable/equatable.dart';
import 'package:safe_bite/core/utils/category_helper.dart';
import 'package:safe_bite/core/utils/expiry_helper.dart';
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
  final String selectedCategory;

  const HomeLoaded({
    this.user,
    required this.expiringItems,
    this.selectedCategory = 'all',
  });

  List<FoodItem> get filteredItems =>
      filterItemsByCategory(expiringItems, selectedCategory);

  int get expiringCount => expiringItems
      .where(
        (item) => resolveDaysUntilExpiry(item.shelfLife, item.expiryDate) <= 3,
      )
      .length;

  int get savedCount => expiringItems.length;

  @override
  List<Object?> get props => [user, expiringItems, selectedCategory];

  HomeLoaded copyWith({
    UserEntity? user,
    List<FoodItem>? expiringItems,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      user: user ?? this.user,
      expiringItems: expiringItems ?? this.expiringItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
