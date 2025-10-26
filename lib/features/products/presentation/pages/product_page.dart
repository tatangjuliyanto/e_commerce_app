import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:e_commerce_app/core/widgets/app_color_custom.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_event.dart';
import 'package:e_commerce_app/features/products/presentation/bloc/product_state.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/card_product.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/empty_product.dart';
import 'package:e_commerce_app/features/products/presentation/widgets/error_product.dart';
import 'package:e_commerce_app/depedency_injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class ProductPage extends StatefulWidget {
  // final String remove = ;
  const ProductPage({super.key, remove});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthenticatedState) {
        context.read<CartBloc>().add(LoadCart(authState.user.uid));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(LoadProducts()),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColorsCustom.primary,
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String username = 'Guest';
              if (state is AuthenticatedState) {
                username =
                    state.user.name.toString(); // pastikan field `name` ada
              }
              return Text(
                'Welcome $username,',
                style: const TextStyle(color: AppColorsCustom.textPrimary),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: AppColorsCustom.textPrimary,
              ),
              onPressed: () {
                context.go('/search');
              },
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                int itemCount = 0;
                if (cartState is CartLoaded) {
                  itemCount = cartState.cartEntity.items.length;
                }

                return Badge(
                  label: Text(itemCount > 99 ? '99+' : '$itemCount'),
                  isLabelVisible: itemCount > 0,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  offset: const Offset(-7, 2),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: AppColorsCustom.textPrimary,
                    ),
                    onPressed: () {
                      context.go('/cart');
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: AppBackground(
          isScrollable: false,
          child: RefreshIndicator(
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
      ),
    );
  }
}
