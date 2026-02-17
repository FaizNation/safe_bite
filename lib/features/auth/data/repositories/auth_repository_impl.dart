import 'dart:typed_data';

import 'package:safe_bite/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> login(String email, String password) {
    return _remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password, String name) {
    return _remoteDataSource.register(email, password, name);
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  }) {
    return _remoteDataSource.updateProfile(
      name: name,
      photoUrl: photoUrl,
      photoBlob: photoBlob,
    );
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return _remoteDataSource.changePassword(currentPassword, newPassword);
  }
}
