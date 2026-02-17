import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:safe_bite/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:safe_bite/features/profile/domain/usecases/change_password_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final ChangePasswordUseCase _changePassword;

  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required ChangePasswordUseCase changePassword,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       _changePassword = changePassword,
       super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await _getProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    emit(ProfileLoading());
    try {
      await _updateProfile(name: name, photoUrl: photoUrl);
      final user = await _getProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found after update'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfilePhoto(Uint8List photoBytes) async {
    emit(ProfileLoading());
    try {
      await _updateProfile(photoBlob: photoBytes);
      final user = await _getProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found after update'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    emit(ProfileLoading());
    try {
      await _changePassword(currentPassword, newPassword);
      final user = await _getProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found after password change'));
      }
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
