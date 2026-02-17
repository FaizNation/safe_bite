import 'package:safe_bite/features/home/domain/repositories/home_repository.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class GetExpiringItemsUseCase {
  final HomeRepository _repository;

  GetExpiringItemsUseCase(this._repository);

  Future<List<FoodItem>> call(String userId) async {
    return _repository.getExpiringItems(userId);
  }
}
