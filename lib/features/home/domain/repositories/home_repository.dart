import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

abstract class HomeRepository {
  Future<UserEntity?> getUserProfile();
  Future<List<FoodItem>> getExpiringItems(String userId);
  Future<void> deleteFoodItem(String documentId);
}
