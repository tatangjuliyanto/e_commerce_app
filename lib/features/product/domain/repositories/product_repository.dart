import 'package:e_commerce_app/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductDetail(String productId);

  //TODO - Add methods for cart operations
  // Future<String> addToCart(Product product);
}
