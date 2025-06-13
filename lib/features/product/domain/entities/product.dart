import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final String category;
  final double rating;
  final double price;
  final double stock;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.rating,
    required this.price,
    required this.stock,
  });

  @override
  List<Object> get props => [
    id,
    title,
    description,
    thumbnail,
    category,
    rating,
    price,
    stock,
  ];
}

class CartItemEntity extends Equatable {
  final Product product;
  final int quantity;

  const CartItemEntity({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => items.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  @override
  List<Object> get props => [items];
}
