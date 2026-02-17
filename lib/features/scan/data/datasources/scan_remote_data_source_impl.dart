import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';
import 'scan_remote_data_source.dart';

class ScanRemoteDataSourceImpl implements ScanRemoteDataSource {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  ScanRemoteDataSourceImpl({
    GenerativeModel? model,
    FirebaseFirestore? firestore,
  }) : _model =
           model ??
           GenerativeModel(
             model: 'gemini-2.0-flash',
             apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
           ),
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<FoodAnalysisModel> analyzeImage(Uint8List imageBytes) async {
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
      "shelf_life": "String (e.g. '3 days', '1 week') - Short duration only.",
      "storage_advice": "String",
      "calories_approx": int,
      "recipe_idea": "String",
      "expiry_date": "String (ISO 8601 Date, e.g. '2023-12-31') - Calculate based on shelf_life from today."
    }
  ]
}
If no food detected, set is_food: false and items: [].
Group identical items into one entry and count them in 'quantity'.
""");

      final imagePart = DataPart('image/jpeg', imageBytes);

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

  @override
  Future<void> saveFoodItems(
    String userId,
    FoodAnalysisModel analysis,
    Uint8List? compressedImage,
  ) async {
    if (analysis.items.isEmpty) {
      AppLogger.warning('No items to save. Analysis returned empty list.');
      return;
    }

    AppLogger.info('Start saving ${analysis.items.length} items for $userId');

    final batch = _firestore.batch();
    final collection = _firestore
        .collection('users')
        .doc(userId)
        .collection('food_items');

    for (final item in analysis.items) {
      final docRef = collection.doc();
      final data = {
        'food_name': item.foodName,
        'category': item.category,
        'freshness_level': item.freshnessLevel,
        'shelf_life': item.shelfLife,
        'storage_advice': item.storageAdvice,
        'calories_approx': item.caloriesApprox,
        'recipe_idea': item.recipeIdea,
        'quantity': item.quantity,
        'expiry_date': item.expiryDate?.toIso8601String(),
        'image_url': item.imageUrl,
        'image_blob': compressedImage != null ? Blob(compressedImage) : null,
        'added_at': FieldValue.serverTimestamp(),
      };

      AppLogger.debug('Queueing write for ${item.foodName}');
      batch.set(docRef, data);
    }

    await batch.commit();
    AppLogger.info('Batch commit successful');
  }
}
