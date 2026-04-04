import 'package:data_supabase/auth.dart';
import 'package:data_supabase/post.dart';
import 'package:domain/auth.dart';
import 'package:domain/post.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../config/router/app_router.dart';

@module
abstract class RegisterModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  GoRouter router(AuthenticationBloc authBloc) => createRouter(authBloc);
  // Data layer registration (LazySingleton)
  @LazySingleton(as: AuthRemoteDataSource)
  SupabaseAuthRemoteDataSource get supabaseAuthRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepositoryImpl;

  //Post
  @LazySingleton(as: PostRemoteDataSource)
  SupabasePostRemoteDataSource get supabasePostRemoteDataSource;

  @LazySingleton(as: PostRepository)
  PostRepositoryImpl get postRepositoryImpl;

  // Domain layer (UseCases) Registration (Injectable - factory)
  // Auth
  @injectable
  SignupUseCase get signupUseCase;

  @injectable
  LoginUseCase get loginUseCase;

  @injectable
  LogoutUseCase get logoutUseCase;

  // Post
  @injectable
  GetPostsUseCase get getPostsUseCase;

  @injectable
  CreatePostUseCase get createPostUsecase;

  @injectable
  UploadPostImageUseCase get uploadPostImageUseCase;

  @injectable
  GetPostDetailUseCase get getPostDetailUsecase;

  @injectable
  GetCommentsUseCase get getCommentsUsecase;
}
