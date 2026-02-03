import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/food_analysis.dart';
import '../../domain/repositories/scan_repository.dart';
import '../models/food_analysis_model.dart'; // Import the model

class ScanRepositoryImpl implements ScanRepository {
  final GenerativeModel _model;

  ScanRepositoryImpl({GenerativeModel? model})
    : _model =
          model ??
          GenerativeModel(
            model:
                'gemini-2.0-flash', // Or 'gemini-pro-vision' depending on availability
            apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
          );

  @override
  Future<FoodAnalysis> analyzeImage(XFile image) async {
    try {
      final prompt = TextPart("""
You are a Nutritionist AI. Analyze this image.
Output STRICT JSON ONLY (no markdown).
Fields:
- is_food: boolean
- food_name: String (Indonesian)
- category: String (Sayur/Buah/Daging/etc)
- freshness_level: String (Segar/Layak/Busuk)
- shelf_life: String
- storage_advice: String
- calories_approx: int
- recipe_idea: String
If not food, set is_food: false.
""");

      final imageBytes = await image.readAsBytes();
      final imagePart = DataPart(
        'image/jpeg',
        imageBytes,
      ); // Assuming JPEG, Gemini usually handles others too

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
