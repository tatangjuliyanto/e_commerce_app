import 'package:e_commerce_app/app_router.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:e_commerce_app/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>())],
      child: MaterialApp.router(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   final AppRouter _appRouter = AppRouter();
//   MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => di.sl<AuthBloc>()),
//         BlocProvider(create: (context) => di.sl<CartBloc>()),
//       ],
//       child: MaterialApp.router(
//         routerConfig: _appRouter.router,
//         title: 'E-Commerce App',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
