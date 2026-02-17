import 'dart:typed_data';
import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';

abstract class ScanRemoteDataSource {
  Future<FoodAnalysisModel> analyzeImage(Uint8List imageBytes);

  Future<void> saveFoodItems(
    String userId,
    FoodAnalysisModel analysis,
    Uint8List? compressedImage,
  );
}
