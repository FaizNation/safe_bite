import 'dart:typed_data';

import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity?> getCurrentUser();

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  });

  Future<void> changePassword(String currentPassword, String newPassword);
}
