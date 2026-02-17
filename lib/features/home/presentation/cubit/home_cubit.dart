import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/home/domain/usecases/get_user_profile.dart';
import 'package:safe_bite/features/home/domain/usecases/get_expiring_items.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetUserProfileUseCase _getUserProfile;
  final GetExpiringItemsUseCase _getExpiringItems;

  HomeCubit({
    required GetUserProfileUseCase getUserProfile,
    required GetExpiringItemsUseCase getExpiringItems,
  }) : _getUserProfile = getUserProfile,
       _getExpiringItems = getExpiringItems,
       super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final user = await _getUserProfile();
      if (user == null) {
        emit(const HomeError('User not logged in'));
        return;
      }

      final items = await _getExpiringItems(user.uid);
      items.sort((a, b) {
        final aDate =
            a.expiryDate ?? DateTime.now().add(const Duration(days: 365));
        final bDate =
            b.expiryDate ?? DateTime.now().add(const Duration(days: 365));
        return aDate.compareTo(bDate);
      });
      emit(HomeLoaded(user: user, expiringItems: items));
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
