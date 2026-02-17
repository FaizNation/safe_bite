import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<UserEntity?> call() async {
    return _repository.getCurrentUser();
  }
}
