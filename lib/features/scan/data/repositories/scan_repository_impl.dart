import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/food_analysis.dart';
import '../../domain/repositories/scan_repository.dart';
import '../models/food_analysis_model.dart';

class ScanRepositoryImpl implements ScanRepository {
  final GenerativeModel _model;

  ScanRepositoryImpl({GenerativeModel? model})
    : _model =
          model ??
          GenerativeModel(
            model: 'gemini-2.0-flash',
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
    FoodAnalysis analysis,
    XFile? imageFile,
  ) async {
    final firestore = FirebaseFirestore.instance;
    
    final batch = firestore.batch();
    final collection = firestore
        .collection('users')
        .doc(userId)
        .collection('food_items');

    String? uploadedImageUrl;

    // // CHECK: Skipping Image Upload for Debugging
    // if (imageFile != null) {
    //   try {
    //     debugPrint('Starting Image Upload...');
    //     final ref = storage
    //         .ref()
    //         .child('users')
    //         .child(userId)
    //         .child('scans')
    //         .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    //     if (kIsWeb) {
    //       await ref.putData(await imageFile.readAsBytes());
    //     } else {
    //       await ref.putFile(File(imageFile.path));
    //     }
    //     uploadedImageUrl = await ref.getDownloadURL();
    //     debugPrint('Image Upload Success: $uploadedImageUrl');
    //   } catch (e) {
    //     debugPrint('Image upload failed: $e');
    //   }
    // }

    // DEBUG: Write to a test collection to verify connection
    try {
      await firestore.collection('debug_writes').add({
        'user_id': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Test write from ScanRepository',
      });
      debugPrint('DEBUG WRITE SUCCESS: Written to debug_writes');
    } catch (e) {
      debugPrint('DEBUG WRITE FAILED: $e');
      // Don't throw, let's try the real write
    }

    debugPrint('Start saving ${analysis.items.length} items for $userId');

    if (analysis.items.isEmpty) {
      debugPrint('Warning: No items to save. Analysis returned empty list.');
      return;
    }

    try {
      debugPrint(
        'Platform check: kIsWeb=$kIsWeb, OperatingSystem=${Platform.operatingSystem}',
      );
    } catch (e) {
      // Platform.operatingSystem might throw on web
      debugPrint('Platform check: kIsWeb=$kIsWeb');
    }

    for (final item in analysis.items) {
      final docRef = collection.doc(); // Auto-ID

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
        'image_url': uploadedImageUrl ?? item.imageUrl,
        'added_at': FieldValue.serverTimestamp(),
      };

      debugPrint('Queueing write for ${item.foodName}');
      batch.set(docRef, data);
    }

    await batch.commit();
    debugPrint('Batch commit successful');
  }
}
