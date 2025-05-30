import 'package:e_commerce_app/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
