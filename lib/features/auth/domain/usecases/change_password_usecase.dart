import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call(String currentPassword, String newPassword) {
    return repository.changePassword(currentPassword, newPassword);
  }
}
