import 'dart:typed_data';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String name);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  });
  Future<void> changePassword(String currentPassword, String newPassword);
}
