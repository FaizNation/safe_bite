import 'dart:typed_data';

import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.name,
    super.photoUrl,
    super.photoBlob,
  });

  factory UserModel.fromFirebaseUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    Uint8List? photoBlob,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: displayName,
      photoUrl: photoURL,
      photoBlob: photoBlob,
    );
  }

  factory UserModel.fromDocument(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] as String? ?? '',
      name: data['name'] as String?,
      photoUrl: data['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name, 'photo_url': photoUrl};
  }
}
