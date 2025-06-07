import 'dart:convert';
import 'package:e_commerce_app/features/product/data/models/product_model.dart';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductsDetail(String productId);
  // Future<String> addToCart(ProductModel product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  static const _baseUrl = 'https://dummyjson.com/products';
  static const _timeoutDuration = Duration(seconds: 5);

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client
          .get(Uri.parse(_baseUrl))
          .timeout(_timeoutDuration);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List products = data['products'];
        return products.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to Load Products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to Load Products: $e');
    }
  }

  @override
  Future<ProductModel> getProductsDetail(String productId) async {
    if (productId.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    try {
      final response = await client
          .get(Uri.parse('$_baseUrl/$productId'))
          .timeout(_timeoutDuration);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to Load Product Detail: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to Load Product Detail: $e');
    }
  }
}
