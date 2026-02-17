import 'dart:typed_data';

import 'package:safe_bite/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(String email, String password, String name);

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  });

  Future<void> changePassword(String currentPassword, String newPassword);
}
