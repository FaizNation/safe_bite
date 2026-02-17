import 'dart:typed_data';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';
import 'package:safe_bite/features/scan/domain/repositories/scan_repository.dart';

class SaveFoodItemsUseCase {
  final ScanRepository _repository;

  const SaveFoodItemsUseCase(this._repository);

  Future<void> call({
    required String userId,
    required FoodAnalysis analysis,
    Uint8List? imageBytes,
  }) {
    return _repository.saveFoodItems(userId, analysis, imageBytes);
  }
}
