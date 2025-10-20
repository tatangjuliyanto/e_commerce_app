import 'dart:convert';
import 'package:e_commerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems(String userId);
  Future<void> addToCart(String userId, CartItemModel item);
  Future<void> removeFromCart(String userId, int productId);
  Future<void> updateItemQuantity(String userId, int productId, int newQty);
  Future<String> payment(String userId, String name, String email);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final SupabaseClient supabase;
  CartRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<CartItemModel>> getCartItems(String userId) async {
    final response = await supabase.from('cart').select().eq('user_id', userId);

    if (response.isEmpty) {
      return [];
    }
    final items = <CartItemModel>[];
    for (final row in response) {
      final productResponse = await http.get(
        Uri.parse("https://dummyjson.com/products/${row['product_id']}"),
      );
      final productData = jsonDecode(productResponse.body);

      items.add(CartItemModel.fromJson(row, productData));
    }

    return items;
  }

  @override
  Future<void> addToCart(String userId, CartItemModel item) async {
    // Cek apakah produk sudah ada
    final existing =
        await supabase
            .from('cart')
            .select()
            .eq('user_id', userId)
            .eq('product_id', item.product.id)
            .maybeSingle();

    if (existing != null) {
      // update quantity
      final newQty = (existing['quantity'] as int) + item.quantity;
      await supabase
          .from('cart')
          .update({
            'quantity': newQty,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existing['id']);
    } else {
      // insert baru
      await supabase.from('cart').insert({
        'user_id': userId,
        'product_id': item.product.id,
        'quantity': item.quantity,
      });
    }
  }

  @override
  Future<void> removeFromCart(String userId, int productId) async {
    await supabase
        .from('cart')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  @override
  Future<void> updateItemQuantity(
    String userId,
    int productId,
    int newQty,
  ) async {
    await supabase
        .from('cart')
        .update({
          'quantity': newQty,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  @override
  Future<String> payment(String userId, String name, String email) async {
    final response = await http.post(
      Uri.parse('http://localhost:5001/checkout'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'customer_name': name,
        'customer_email': email,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['snapToken'];
    } else {
      throw Exception('Checkout failed');
    }
  }
}
