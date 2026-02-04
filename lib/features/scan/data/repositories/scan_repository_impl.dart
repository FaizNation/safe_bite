import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/food_analysis.dart';
import '../../domain/repositories/scan_repository.dart';
import '../models/food_analysis_model.dart';

class ScanRepositoryImpl implements ScanRepository {
  final GenerativeModel _model;

  ScanRepositoryImpl({GenerativeModel? model})
    : _model =
          model ??
          GenerativeModel(
            model:
                'gemini-2.0-flash', 
            apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
          );

  @override
  Future<FoodAnalysis> analyzeImage(XFile image) async {
    try {
      final prompt = TextPart("""
You are a Nutritionist AI. Analyze this image for ALL food items present.
Output STRICT JSON ONLY (no markdown).
Format:
{
  "is_food": boolean,
  "items": [
    {
      "food_name": "String (Indonesian)",
      "category": "String (Vegetable/Fruit/Meat/Milk/Other) - Choose from these exact values.",
      "quantity": int (count of identical items),
      "box_2d": [ymin, xmin, ymax, xmax] (int, 0-1000 scale, bounding box of the whole group),
      "freshness_level": "String (Segar/Layak/Busuk)",
      "shelf_life": "String (e.g. '3-4 days in fridge')",
      "storage_advice": "String",
      "calories_approx": int,
      "recipe_idea": "String"
    }
  ]
}
If no food detected, set is_food: false and items: [].
Group identical items into one entry and count them in 'quantity'.
""");

      final imageBytes = await image.readAsBytes();
      final imagePart = DataPart(
        'image/jpeg',
        imageBytes,
      );

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      if (response.text == null) {
        throw Exception('Failed to get response from Gemini');
      }

      return FoodAnalysisModel.fromJson(response.text!);
    } catch (e) {
      throw Exception('Scan failed: $e');
    }
  }
}
