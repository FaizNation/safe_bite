import 'package:image_picker/image_picker.dart';
import '../entities/food_analysis.dart';

abstract class ScanRepository {
  Future<FoodAnalysis> analyzeImage(XFile image);
  Future<void> saveFoodItems(
    String userId,
    FoodAnalysis analysis,
    XFile? imageFile,
  );
}
