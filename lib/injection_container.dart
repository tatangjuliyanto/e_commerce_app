import 'package:e_commerce_app/data/repositories/product_repository_impl.dart';
import 'package:e_commerce_app/data/sources/product_remote_data_source.dart';
import 'package:e_commerce_app/domain/repositories/product_repository.dart';
import 'package:e_commerce_app/domain/usecases/get_products.dart';
import 'package:e_commerce_app/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  // Bloc
  sl.registerFactory(() => ProductBloc(getProducts: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
