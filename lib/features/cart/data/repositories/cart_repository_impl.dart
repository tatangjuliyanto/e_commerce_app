import 'package:e_commerce_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:e_commerce_app/features/cart/domain/entities/cart_entity.dart';
import 'package:e_commerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:e_commerce_app/features/products/domain/entities/product.dart';

import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CartEntity> getCart(String userId) async {
    final items = await remoteDataSource.getCartItems(userId);
    return CartEntity(items: items);
  }

  @override
  Future<void> addToCart(Product product, String userId, int quantity) async {
    final item = CartItemModel(product: product, quantity: quantity);
    await remoteDataSource.addToCart(userId, item);
  }

  @override
  Future<void> removeFromCart(int productId, String userId) async {
    return await remoteDataSource.removeFromCart(userId, productId);
  }
}
