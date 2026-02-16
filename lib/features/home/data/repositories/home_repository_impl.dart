import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'package:safe_bite/features/home/domain/repositories/home_repository.dart';
import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  HomeRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity?> getUserProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      Uint8List? photoBlob;
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          if (data.containsKey('profile_photo_blob')) {
            // Assuming the blob is stored as a base64 string or similar format that needs handling
            // If it's stored as a Blob in Firestore, we can cast it.
            // However, Firestore Blobs are usually returned as Blob objects.
            // Let's check how it's likely stored. If it is a Blob:
            final blob = data['profile_photo_blob'];
            if (blob is Blob) {
              photoBlob = blob.bytes;
            } else if (blob is String) {
              // If it's a base64 string, we might need to decode it,
              // but Uint8List expects bytes.
              // For now, let's assume it might be a Blob or we need to handle it.
              // If the user says "firebase profile_photo_blob", it's likely a Blob type in Firestore.
            }
          }
        }
      } catch (e) {
        print('Error fetching user profile blob: $e');
      }

      return UserEntity(
        uid: user.uid,
        email: user.email!,
        name: user.displayName,
        photoUrl: user.photoURL,
        photoBlob: photoBlob,
      );
    }
    return null;
  }

  @override
  Future<List<FoodItem>> getExpiringItems(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('food_items')
          // .orderBy('expiry_date')
          // .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return FoodItemModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch expiring items: $e');
    }
  }
}
