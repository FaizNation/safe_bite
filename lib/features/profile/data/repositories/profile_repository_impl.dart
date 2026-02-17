import 'dart:typed_data';

import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:safe_bite/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _remoteDataSource.getCurrentUser();
    } catch (e) {
      AppLogger.error('Error fetching profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  }) async {
    await _remoteDataSource.updateProfile(
      name: name,
      photoUrl: photoUrl,
      photoBlob: photoBlob,
    );
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _remoteDataSource.changePassword(currentPassword, newPassword);
  }
}
