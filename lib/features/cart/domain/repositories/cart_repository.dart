import 'package:e_commerce_app/features/products/domain/entities/product.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart(String userId);
  Future<void> addToCart(Product product, String userId, int quantity);
  Future<void> removeFromCart(String productId, String userId);
  // Future<void> clearCart(String userId);
}
