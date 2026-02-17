import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';

abstract class HomeRemoteDataSource {
  Future<String?> getCurrentUserId();

  Future<Map<String, dynamic>?> getUserProfileData(String uid);

  Future<List<FoodItemModel>> getExpiringItems(String userId);

  Future<void> deleteFoodItem(String userId, String documentId);
}
