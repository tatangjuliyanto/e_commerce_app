import 'package:e_commerce_app/features/product/data/sources/product_remote_data_source.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  getProductDetail(String productId) {
    // TODO: implement getProductDetail

    throw UnimplementedError();
  }
}
