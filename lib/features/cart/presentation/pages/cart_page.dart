import 'package:e_commerce_app/core/widgets/app_background.dart';
import 'package:e_commerce_app/core/widgets/app_color_custom.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../widgets/update_item_quantity.dart';

class CartPage extends StatefulWidget {
  final String userId;
  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  WebViewController? _webViewController;
  String? _currentToken;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartBloc>().add(LoadCart(widget.userId));
    });
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  void _removeItemFromCart(int productId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<CartBloc>().add(
        RemoveItemFromCart(authState.user.uid, productId),
      );
    }
  }

  WebViewWidget _buildWebViewForToken(String snapToken) {
    final url = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

    if (_webViewController == null || _currentToken != snapToken) {
      _currentToken = snapToken;
      final params = PlatformWebViewControllerCreationParams();
      final controller = WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              if (progress == 100) setState(() => isLoading = false);
            },
            onNavigationRequest: (request) {
              final url = request.url;
              if (url.contains('/finish') || url.contains('status_code=200')) {
                _handlePaymentResult('success');
                return NavigationDecision.prevent;
              } else if (url.contains('/unfinish') ||
                  url.contains('status_code=202') ||
                  url.contains('cancel')) {
                _handlePaymentResult('canceled');
                return NavigationDecision.prevent;
              } else if (url.contains('/error') ||
                  url.contains('status_code=500') ||
                  url.contains('deny')) {
                _handlePaymentResult('failed');
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));

      _webViewController = controller;
    }

    return WebViewWidget(controller: _webViewController!);
  }

  Future<void> _handlePaymentResult(String status) async {
    String message;
    if (status == 'success') {
      message = 'Payment Successful ';
    } else if (status == 'canceled') {
      message = 'Payment Canceled ';
    } else {
      message = 'Payment Failed ';
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorsCustom.primary,
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: AppBackground(
        isScrollable: false,
        child: RefreshIndicator(
          onRefresh: () async {
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthenticatedState) {
              context.read<CartBloc>().add(LoadCart(authState.user.uid));
            }
            await Future.delayed(const Duration(seconds: 1));
          },
          child: BlocConsumer<CartBloc, CartState>(
            listener: (context, state) {
              if (state is PaymentFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded) {
                final cart = state.cartEntity;

                if (cart.items.isEmpty) {
                  return const Center(child: Text("Cart is empty"));
                }

                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (_, i) {
                            final item = cart.items[i];
                            return Dismissible(
                              key: ValueKey(item.product.id),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                _removeItemFromCart(item.product.id);
                              },
                              child: ListTile(
                                leading: Image.network(
                                  item.product.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(item.product.title),
                                subtitle: Text("Qty: ${item.quantity}"),
                                trailing: UpdateItemQuantityButton(
                                  userId: widget.userId,
                                  productId: item.product.id,
                                  currentQty: item.quantity,
                                  totalPrice:
                                      item.product.price * item.quantity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Price:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColorsCustom.textPrimary,
                            ),
                          ),
                          Text(
                            "\$${cart.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColorsCustom.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is AuthenticatedState) {
                            context.read<CartBloc>().add(
                              PaymentEvent(
                                userId: authState.user.uid,
                                name: authState.user.name ?? 'Guest',
                                email: authState.user.email,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                );
              } else if (state is PaymentSuccessState) {
                return _buildWebViewForToken(state.snapToken);
              } else if (state is PaymentFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is CartError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              return const Center(child: Text("Cart is empty"));
            },
          ),
        ),
      ),
    );
  }
}
