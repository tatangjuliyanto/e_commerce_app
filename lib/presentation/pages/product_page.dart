import 'package:bloc_provider/bloc_provider.dart';
import 'package:e_commerce_app/domain/repositories/product_repository.dart';
import 'package:e_commerce_app/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/presentation/bloc/product_event.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: BlocProvider(
        create:
            (context) =>
                ProductBloc(getProducts: RepositoryProvider.of(context))
                  ..add(LoadProducts()),
      ),
    );
  }
}
