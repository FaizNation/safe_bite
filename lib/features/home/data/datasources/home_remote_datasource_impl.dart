import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_bite/features/home/data/datasources/home_remote_datasource.dart';
import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  HomeRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String?> getCurrentUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<Map<String, dynamic>?> getUserProfileData(String uid) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    Uint8List? photoBlob;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      final data = userDoc.data()!;
      if (data.containsKey('profile_photo_blob')) {
        final blob = data['profile_photo_blob'];
        if (blob is Blob) {
          photoBlob = blob.bytes;
        }
      }
    }

    return {
      'uid': user.uid,
      'email': user.email ?? '',
      'name': user.displayName,
      'photoUrl': user.photoURL,
      'photoBlob': photoBlob,
    };
  }

  @override
  Future<List<FoodItemModel>> getExpiringItems(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('food_items')
        .get();

    return snapshot.docs.map((doc) {
      return FoodItemModel.fromJson(doc.data(), docId: doc.id);
    }).toList();
  }

  @override
  Future<void> deleteFoodItem(String userId, String documentId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('food_items')
        .doc(documentId)
        .delete();
  }
}
