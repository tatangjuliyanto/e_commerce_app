import 'package:e_commerce_app/navigation/app_router.dart';
import 'package:e_commerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:e_commerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/login_user.dart';
import 'package:e_commerce_app/features/auth/domain/usecases/register_user.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:e_commerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:e_commerce_app/features/products/domain/usecases/get_product_detail.dart';
import 'package:e_commerce_app/features/products/domain/usecases/get_products.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/shared/presentation/bloc/onboarding_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Inisialisasi Firebase
  await Firebase.initializeApp();

  //approuter
  sl.registerLazySingleton<AppRouter>(() => AppRouter());

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => http.Client());

  //-----------------------------------------------------------------
  //                   Onboarding
  //-----------------------------------------------------------------

  sl.registerLazySingleton(() => OnboardingBloc());

  //-----------------------------------------------------------------
  //                    Features - Auth
  //-----------------------------------------------------------------

  // Auth Bloc
  sl.registerLazySingleton(() => AuthBloc(loginUser: sl(), registerUser: sl()));
  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
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
}
