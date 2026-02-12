import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final Uint8List? photoBlob;

  const UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
    this.photoBlob,
  });

  @override
  List<Object?> get props => [uid, email, name, photoUrl, photoBlob];
}
