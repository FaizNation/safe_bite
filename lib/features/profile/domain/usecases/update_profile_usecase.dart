import 'dart:typed_data';

import 'package:safe_bite/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> call({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  }) async {
    return _repository.updateProfile(
      name: name,
      photoUrl: photoUrl,
      photoBlob: photoBlob,
    );
  }
}
