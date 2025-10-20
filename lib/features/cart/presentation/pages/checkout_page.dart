// import 'package:e_commerce_app/features/cart/presentation/bloc/cart_bloc.dart';
// import 'package:e_commerce_app/features/cart/presentation/bloc/cart_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../../auth/presentation/bloc/auth_bloc.dart';
// import '../../../auth/presentation/bloc/auth_state.dart';
// import '../bloc/cart_event.dart';

// //TODO: fixit code redirect Payment & adding table transaction in supabase & and call all akses to supabase using all api from backend, Create to COlor the same with my portofolio!!!!

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({super.key});

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   WebViewController? _webViewController;
//   String? _currentToken;
//   bool _isLoading = true;

//   @override
//   void dispose() {
//     // no explicit dispose needed for WebViewController, but clear references
//     _webViewController = null;
//     super.dispose();
//   }

//   // Helper to create controller for a given URL (snap token page)
//   WebViewWidget _buildWebViewForToken(String snapToken) {
//     final url = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

//     // Recreate controller only if token changed
//     if (_webViewController == null || _currentToken != snapToken) {
//       _currentToken = snapToken;

//       // platform-specific creation params (works for Android/iOS)
//       final params = PlatformWebViewControllerCreationParams();
//       final controller = WebViewController.fromPlatformCreationParams(params);

//       controller
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..setBackgroundColor(const Color(0x00000000))
//         ..setNavigationDelegate(
//           NavigationDelegate(
//             onPageStarted: (url) => print('📄 Navigating to: $url'),
//             onProgress: (progress) {
//               if (progress == 100) setState(() => _isLoading = false);
//             },
//             onNavigationRequest: (request) {
//               final url = request.url;
//               if (url.contains('/finish') || url.contains('status_code=200')) {
//                 _handlePaymentResult('success');
//                 return NavigationDecision.prevent;
//               } else if (url.contains('/unfinish') ||
//                   url.contains('status_code=202') ||
//                   url.contains('cancel')) {
//                 _handlePaymentResult('canceled');
//                 return NavigationDecision.prevent;
//               } else if (url.contains('/error') ||
//                   url.contains('status_code=500') ||
//                   url.contains('deny')) {
//                 _handlePaymentResult('failed');
//                 return NavigationDecision.prevent;
//               }

//               return NavigationDecision.navigate;
//             },
//           ),
//         )
//         ..loadRequest(Uri.parse(url));

//       _webViewController = controller;
//     }

//     return WebViewWidget(controller: _webViewController!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.go('/cart'),
//         ),
//       ),
//       body: BlocConsumer<CartBloc, CartState>(
//         listener: (context, state) {
//           if (state is PaymentFailure) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.error)));
//           }
//         },
//         builder: (context, state) {
//           if (state is CartInitial) {
//             return Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   final authState = context.read<AuthBloc>().state;
//                   if (authState is AuthenticatedState) {
//                     context.read<CartBloc>().add(
//                       PaymentEvent(
//                         userId: authState.user.uid,
//                         name: authState.user.name ?? 'Guest',
//                         email: authState.user.email,
//                       ),
//                     );
//                   }
//                 },
//                 child: const Text('Checkout Now'),
//               ),
//             );
//           } else if (state is CartLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is PaymentSuccessState) {
//             // Build and show WebView with snap token
//             return _buildWebViewForToken(state.snapToken);
//           } else if (state is PaymentFailure) {
//             return Center(child: Text("Error: ${state.error}"));
//           } else {
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _handlePaymentResult(String status) async {
//     print('💳 Payment status: $status');

//     String message;
//     if (status == 'success') {
//       message = 'Payment Successful 🎉';
//     } else if (status == 'canceled') {
//       message = 'Payment Canceled 🚫';
//     } else {
//       message = 'Payment Failed ❌';
//     }

//     // Show snackbar
//     if (mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     }

//     // Wait a bit to show message then redirect
//     await Future.delayed(const Duration(seconds: 2));

//     if (!mounted) return;
//     context.go('/home');
//   }
// }
