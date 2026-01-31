import 'dart:io';
import '../entities/food_analysis.dart';

abstract class ScanRepository {
  Future<FoodAnalysis> analyzeImage(File image);
}
