import 'dart:typed_data';

import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({String? name, String? photoUrl, Uint8List? photoBlob}) {
    return repository.updateProfile(
      name: name,
      photoUrl: photoUrl,
      photoBlob: photoBlob,
    );
  }
}
