import 'package:cloud_firestore/cloud_firestore.dart';
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
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        name: user.displayName,
        photoUrl: user.photoURL,
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
