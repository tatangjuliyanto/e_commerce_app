import 'package:e_commerce_app/app_router.dart';
import 'package:e_commerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:e_commerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/forgot_password_user.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/login_user.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/register_user.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:e_commerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:e_commerce_app/features/products/domain/usecases/get_product_detail.dart';
import 'package:e_commerce_app/features/products/domain/usecases/get_products.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:e_commerce_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:e_commerce_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:e_commerce_app/features/profile/domain/usecases/get_profile_user.dart';
import 'package:e_commerce_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/logout_user.dart';
import 'features/cart/data/datasources/cart_remote_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Inisialisasi Firebase
  // await Firebase.initializeApp();

  // Inisialisasi Supabase
  const supabaseUrl = 'https://iqypstdngykbrznoeeng.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxeXBzdGRuZ3lrYnJ6bm9lZW5nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1NDA2OTYsImV4cCI6MjA3MzExNjY5Nn0.jdAw00eHmVTmjleuFKtIAtKifpd0GMPs5WKkyBvQ91k';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  //approuter
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  // Supabase clientd
  sl.registerLazySingleton(() => Supabase.instance.client);

  //Firebase
  // sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => http.Client());

  //-----------------------------------------------------------------
  //                   Onboarding
  //-----------------------------------------------------------------

  sl.registerLazySingleton(() => OnboardingBloc());

  //-----------------------------------------------------------------
  //                    Features - Auth
  //-----------------------------------------------------------------

  // Auth Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      forgotPasswordUser: sl(),
      logoutUser: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    // () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
    () => AuthRemoteDataSupabaseSourceImpl(supabaseAuth: sl()),
  );

  //-----------------------------------------------------------------
  //                    Features - Profile
  //-----------------------------------------------------------------

  // Profile Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUser: sl<GetProfileUser>(),
      // logoutUser: sl<LogoutUser>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUser(sl()));
  // sl.registerLazySingleton(() => LogoutUser(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(Supabase.instance.client),
  );

  //
  //-----------------------------------------------------------------
  //                    Features - Product
  //-----------------------------------------------------------------

  // Product Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl<GetProducts>(),
      getProductDetail: sl<GetProductDetail>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  //
  //-----------------------------------------------------------------
  //                    Features - Cart
  //-----------------------------------------------------------------

  // Cart Bloc
  sl.registerFactory(
    () => CartBloc(
      getCart: sl<GetCartUseCase>(),
      addToCart: sl<AddToCartUseCase>(),
      removeFromCart: sl<RemoveFromCartUseCase>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(sl<CartRepository>()),
  );

  // Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl()),
  );
}
