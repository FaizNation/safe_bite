import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/home/data/datasources/home_remote_datasource.dart';
import 'package:safe_bite/features/home/data/models/home_user_model.dart';
import 'package:safe_bite/features/home/domain/repositories/home_repository.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity?> getUserProfile() async {
    try {
      final uid = await _remoteDataSource.getCurrentUserId();
      if (uid == null) return null;

      final data = await _remoteDataSource.getUserProfileData(uid);
      if (data == null) return null;

      return HomeUserModel.fromMap(data);
    } catch (e) {
      AppLogger.error('Error fetching user profile: $e');
      return null;
    }
  }

  @override
  Future<List<FoodItem>> getExpiringItems(String userId) async {
    try {
      return await _remoteDataSource.getExpiringItems(userId);
    } catch (e) {
      throw Exception('Failed to fetch expiring items: $e');
    }
  }
}
