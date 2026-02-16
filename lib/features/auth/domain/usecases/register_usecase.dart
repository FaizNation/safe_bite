import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String name) {
    return repository.register(email, password, name);
  }
}
