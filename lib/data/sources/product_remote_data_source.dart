import 'dart:convert';

import 'package:e_commerce_app/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSource({required this.client});

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
}
