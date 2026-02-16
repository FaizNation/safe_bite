import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/auth/domain/usecases/login_usecase.dart';
import 'package:safe_bite/features/auth/domain/usecases/register_usecase.dart';
import 'package:safe_bite/features/auth/domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(email, password, name);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(AuthInitial());
  }
}
