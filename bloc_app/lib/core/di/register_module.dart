import 'package:data_supabase/auth.dart';
import 'package:domain/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  // Data layer registration (LazySingleton)
  @LazySingleton(as: AuthRemoteDataSource)
  SupabaseAuthRemoteDataSource get supabaseAuthRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepositoryImpl;
  // Domain layer (UseCases) Registration (Injectable - factory)
  // Auth
  @injectable
  SignupUseCase get signupUseCase;

  @injectable
  LoginUseCase get loginUseCase;

  @injectable
  LogoutUseCase get logoutUseCase;
}
