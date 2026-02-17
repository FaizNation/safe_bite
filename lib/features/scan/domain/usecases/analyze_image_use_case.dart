import 'dart:typed_data';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';
import 'package:safe_bite/features/scan/domain/repositories/scan_repository.dart';

class AnalyzeImageUseCase {
  final ScanRepository _repository;

  const AnalyzeImageUseCase(this._repository);

  Future<FoodAnalysis> call(Uint8List imageBytes) {
    return _repository.analyzeImage(imageBytes);
  }
}
