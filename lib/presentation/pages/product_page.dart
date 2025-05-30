import 'package:bloc_provider/bloc_provider.dart';
import 'package:e_commerce_app/domain/repositories/product_repository.dart';
import 'package:e_commerce_app/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: BlocProvider.builder(creator: , builder: builder)
      // body: BlocBuilder<ProductBloc, ProductState>(
      //   builder: (context, state) {
      //     if (state is ProductLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (state is ProductLoaded) {
      //       return ListView.builder(
      //         itemCount: state.products.length,
      //         itemBuilder: (context, index) {
      //           final product = state.products[index];
      //           return ListTile(
      //             leading: Image.network(product.thumbnail),
      //             title: Text(product.title),
      //             subtitle: Text('\$${product.price.toString()}'),
      //           );
      //         },
      //       );
      //     } else if (state is ProductError) {
      //       return Center(child: Text(state.message));
      //     }
      //     return const Center(child: Text('No Products'));
      //   },
      // ),
    );
  }
}
