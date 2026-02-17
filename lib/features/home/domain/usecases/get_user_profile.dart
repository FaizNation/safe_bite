import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/home/domain/repositories/home_repository.dart';

class GetUserProfileUseCase {
  final HomeRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserEntity?> call() async {
    return _repository.getUserProfile();
  }
}
