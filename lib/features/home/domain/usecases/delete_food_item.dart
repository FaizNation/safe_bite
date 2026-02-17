import 'package:safe_bite/features/home/domain/repositories/home_repository.dart';

class DeleteFoodItemUseCase {
  final HomeRepository _repository;

  DeleteFoodItemUseCase(this._repository);

  Future<void> call(String documentId) {
    return _repository.deleteFoodItem(documentId);
  }
}
