import 'package:e_commerce_app/features/product/data/models/product_model.dart';
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
  Future<Product> getProductDetail(String productId) async {
    return await remoteDataSource.getProductsDetail(productId);
  }

  // @override
  // Future<Product> addToCart(Product product) async {
  //   final productModel = ProductModel.fromEntity(product);
  //   return await remoteDataSource.addToCart(productModel);
  // }
}
