import 'package:e_commerce_app/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductDetail(String productId);
  // Future<Product> addToCart(Product product);
}
