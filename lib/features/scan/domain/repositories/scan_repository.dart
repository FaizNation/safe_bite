import 'dart:typed_data';

import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

abstract class ScanRepository {
  Future<FoodAnalysis> analyzeImage(Uint8List imageBytes);
  Future<void> saveFoodItems(
    String userId,
    FoodAnalysis analysis,
    Uint8List? imageBytes,
  );
}
