import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final user = await _repository.getUserProfile();
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        final items = await _repository.getExpiringItems(firebaseUser.uid);
        items.sort((a, b) {
          final aDate =
              a.expiryDate ?? DateTime.now().add(const Duration(days: 365));
          final bDate =
              b.expiryDate ?? DateTime.now().add(const Duration(days: 365));
          return aDate.compareTo(bDate);
        });
        emit(HomeLoaded(user: user, expiringItems: items));
      } else {
        emit(const HomeError('User not logged in'));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void selectCategory(String category) {
    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      emit(loadedState.copyWith(selectedCategory: category));
    }
  }
}
