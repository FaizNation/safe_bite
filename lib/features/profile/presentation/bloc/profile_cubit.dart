import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/features/auth/domain/repositories/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit({required this.authRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await authRepository.getCurrentUser();
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
      await authRepository.updateProfile(name: name, photoUrl: photoUrl);
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found after update'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfilePhoto(XFile image) async {
    emit(ProfileLoading());
    try {
      final bytes = await image.readAsBytes();
      await authRepository.updateProfile(photoBlob: bytes);

      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('User not found after update'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
