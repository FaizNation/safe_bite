import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';
import 'dart:typed_data';
import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      await user.updateDisplayName(name);
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        name: name,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw Exception('Register Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final photoBlob = await _getProtoBlob(user.uid);
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
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      if (name != null) await user.updateDisplayName(name);
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      if (photoBlob != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'profile_photo_blob': Blob(photoBlob),
        }, SetOptions(merge: true));
      }
    }
  }

  Future<Uint8List?> _getProtoBlob(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists &&
          doc.data() != null &&
          doc.data()!.containsKey('profile_photo_blob')) {
        final blob = doc.get('profile_photo_blob');
        if (blob is Blob) {
          return blob.bytes;
        }
      }
    } catch (e) {
      // Ignore errors
    }
    return null;
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not logged in');
    if (user.email == null) throw Exception('User email not found');

    try {
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password saat ini salah');
      } else if (e.code == 'weak-password') {
        throw Exception('Password baru terlalu lemah');
      }
      throw Exception(e.message ?? 'Gagal mengubah password');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
