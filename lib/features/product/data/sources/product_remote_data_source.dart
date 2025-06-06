import 'dart:convert';
import 'package:e_commerce_app/features/product/data/models/product_model.dart';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductsDetail(String productId);

  // getProductsDetail(String productId) {}
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to Load Products');
    }
  }

  @override
  Future<ProductModel> getProductsDetail(String productId) async {
    final response = await client.get(
      Uri.parse('https://dummyjson.com/products/$productId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Failed to Load Products');
    }
  }

  // @override
  // getProductsDetail(String productId) async {
  //   final response = await client.get(
  //     Uri.parse('https://dummyjson.com/products/$productId'),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     debugPrint('Product Detail: ${data.toString()}');
  //     return ProductModel.fromJson(data);
  //   } else {
  //     throw Exception('Failed to Load Product Detail');
  //   }
  // }
}
