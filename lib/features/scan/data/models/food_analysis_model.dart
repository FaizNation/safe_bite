import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    super.documentId,
    required super.foodName,
    required super.category,
    required super.freshnessLevel,
    required super.shelfLife,
    required super.storageAdvice,
    required super.caloriesApprox,
    required super.recipeIdea,
    super.quantity = 1,
    super.boundingBox,
    super.expiryDate,
    super.addedAt,
    super.imageUrl,
    super.imageBlob,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    List<int>? box;
    if (json['box_2d'] != null) {
      box = List<int>.from(json['box_2d']);
    }

    Uint8List? blobBytes;
    if (json['image_blob'] != null) {
      if (json['image_blob'] is Blob) {
        blobBytes = (json['image_blob'] as Blob).bytes;
      } else if (json['image_blob'] is String) {
        try {
          blobBytes = base64Decode(json['image_blob']);
        } catch (_) {}
      }
    }

    DateTime? addedAtDate;
    if (json['added_at'] != null) {
      if (json['added_at'] is Timestamp) {
        addedAtDate = (json['added_at'] as Timestamp).toDate();
      } else if (json['added_at'] is String) {
        addedAtDate = DateTime.tryParse(json['added_at']);
      }
    }

    return FoodItemModel(
      documentId: docId,
      foodName: json['food_name'] ?? 'Unknown',
      category: json['category'] ?? 'Other',
      freshnessLevel: json['freshness_level'] ?? 'Unknown',
      shelfLife: json['shelf_life'] ?? 'Unknown',
      storageAdvice: json['storage_advice'] ?? 'Unknown',
      caloriesApprox: json['calories_approx'] ?? 0,
      recipeIdea: json['recipe_idea'] ?? 'Unknown',
      quantity: json['quantity'] ?? 1,
      boundingBox: box,
      expiryDate: json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'])
          : null,
      addedAt: addedAtDate,
      imageUrl: json['image_url'],
      imageBlob: blobBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'category': category,
      'freshness_level': freshnessLevel,
      'shelf_life': shelfLife,
      'storage_advice': storageAdvice,
      'calories_approx': caloriesApprox,
      'recipe_idea': recipeIdea,
      'quantity': quantity,
      'box_2d': boundingBox,
      'expiry_date': expiryDate?.toIso8601String(),
      'added_at': addedAt?.toIso8601String(),
      'image_url': imageUrl,
      'image_blob': imageBlob != null ? Blob(imageBlob!) : null,
    };
  }
}

class FoodAnalysisModel extends FoodAnalysis {
  const FoodAnalysisModel({required super.isFood, required super.items});

  factory FoodAnalysisModel.fromJson(String jsonString) {
    String cleanJson = jsonString
        .replaceAll(RegExp(r'^```json\s*'), '')
        .replaceAll(RegExp(r'\s*```$'), '');

    final Map<String, dynamic> json = jsonDecode(cleanJson);
    final bool isFood = json['is_food'] ?? false;

    List<FoodItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((i) => FoodItemModel.fromJson(i))
          .toList();
    } else {
      if (json.containsKey('food_name')) {
        items.add(FoodItemModel.fromJson(json));
      }
    }

    return FoodAnalysisModel(isFood: isFood, items: items);
  }

  Map<String, dynamic> toJson() {
    return {
      'is_food': isFood,
      'items': items.map((e) => (e as FoodItemModel).toJson()).toList(),
    };
  }
}
