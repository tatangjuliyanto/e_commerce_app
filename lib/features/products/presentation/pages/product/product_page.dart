import 'package:e_commerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_state.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/card_product.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/empty_product.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/error_product.dart';
import 'package:e_commerce_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.go('/search');
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                context.go('/cart');
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(LoadProducts());
            await context.read<ProductBloc>().stream.firstWhere(
              (state) => state is! ProductLoading,
            );
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading products...'),
                    ],
                  ),
                );
              } else if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const EmptyProduct();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return CardProduct(product: state.products[index]);
                  },
                );
              } else if (state is ProductError) {
                return ErrorProduct(
                  message: state.message,
                  onRetry: () {
                    context.read<ProductBloc>().add(LoadProducts());
                  },
                );
              }
              return const Center(child: Text('Something went wrong'));
            },
          ),
        ),
      ),
    );
  }
}
