import 'dart:typed_data';

import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';

class HomeUserModel extends UserEntity {
  const HomeUserModel({
    required super.uid,
    required super.email,
    super.name,
    super.photoUrl,
    super.photoBlob,
  });

  factory HomeUserModel.fromMap(Map<String, dynamic> map) {
    return HomeUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      photoBlob: map['photoBlob'] as Uint8List?,
    );
  }
}
