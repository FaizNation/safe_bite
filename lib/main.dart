import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const SafeBiteApp());
}

class SafeBiteApp extends StatelessWidget {
  const SafeBiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) {
              final authRepository = context.read<AuthRepository>();
              return AuthCubit(
                loginUseCase: LoginUseCase(authRepository),
                registerUseCase: RegisterUseCase(authRepository),
                logoutUseCase: LogoutUseCase(authRepository),
              );
            },
          ),
          BlocProvider<ProfileCubit>(
            create: (context) =>
                ProfileCubit(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Safe Bite',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF6B9F5E),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6B9F5E),
            ),
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
