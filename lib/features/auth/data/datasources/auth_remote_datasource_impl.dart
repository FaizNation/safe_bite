import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_bite/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:safe_bite/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return UserModel.fromFirebaseUser(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoURL: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Login gagal: ${e.message}');
    }
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name);
      return UserModel.fromFirebaseUser(
        uid: user.uid,
        email: user.email!,
        displayName: name,
        photoURL: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final photoBlob = await _getProfilePhotoBlob(user.uid);
    return UserModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoURL: user.photoURL,
      photoBlob: photoBlob,
    );
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    Uint8List? photoBlob,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User belum login');

    if (name != null) await user.updateDisplayName(name);
    if (photoUrl != null) await user.updatePhotoURL(photoUrl);
    if (photoBlob != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'profile_photo_blob': Blob(photoBlob),
      }, SetOptions(merge: true));
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User belum login');
    if (user.email == null) throw Exception('Email user tidak ditemukan');

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password saat ini salah');
      } else if (e.code == 'weak-password') {
        throw Exception('Password baru terlalu lemah');
      }
      throw Exception(e.message ?? 'Gagal mengubah password');
    }
  }

  Future<Uint8List?> _getProfilePhotoBlob(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?.containsKey('profile_photo_blob') == true) {
        final blob = doc.get('profile_photo_blob');
        if (blob is Blob) return blob.bytes;
      }
    } catch (_) {}
    return null;
  }
}
