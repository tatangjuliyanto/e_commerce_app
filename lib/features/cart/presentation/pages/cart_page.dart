import 'package:e_commerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';

class CartPage extends StatefulWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Load cart when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCart(widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cart = state.cartEntity;

            if (cart.items.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            return ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return ListTile(
                  leading: Image.network(
                    item.product.thumbnail,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.product.title),
                  subtitle: Text("Qty: ${item.quantity}"),
                  trailing: Text(
                    "\$${(item.product.price * item.quantity)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            );
          } else if (state is CartError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return const Center(child: Text("Cart is empty"));
        },
      ),
    );
  }
}
