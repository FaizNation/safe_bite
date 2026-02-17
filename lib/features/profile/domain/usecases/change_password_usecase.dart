import 'package:safe_bite/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<void> call(String currentPassword, String newPassword) async {
    return _repository.changePassword(currentPassword, newPassword);
  }
}
