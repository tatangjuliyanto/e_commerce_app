import 'package:e_commerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartitems(String userId);
  Future<void> addToCart(String userId, CartItemModel item);
  Future<void> removeFromCart(String userId, String productId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final SupabaseClient supabase;
  CartRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<CartItemModel>> getCartitems(String userId) async {
    final response = await supabase
        .from('cart')
        .select('id, user_id, product_id, quantity, products(*)')
        .eq('user_id', userId);
    return (response as List)
        .map((json) => CartItemModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addToCart(String userId, CartItemModel item) async {
    await supabase.from('cart').insert({
      'user_id': userId,
      'product_id': item.product.id,
      'quantity': item.quantity,
    });
  }

  @override
  Future<void> removeFromCart(String userId, String productId) async {
    await supabase
        .from('cart')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }
}
