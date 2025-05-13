import 'package:flutter/material.dart';
import 'package:proyek/models/client.dart';
import 'package:proyek/routes/app_routes.dart';
import 'package:proyek/views/auth/login_page.dart';
import 'package:proyek/views/auth/register_page.dart';
import 'package:proyek/views/dashboard/client_dashboard.dart';
import 'package:proyek/views/home_page.dart';
import 'package:proyek/views/products/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Gym App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.dashboard: (context) => ClientDashboardPage(
              client: ModalRoute.of(context)!.settings.arguments as Client,
            ),
        AppRoutes.products: (context) => ProductsPage(
              client: ModalRoute.of(context)!.settings.arguments as Client,
            ),
      },
    );
  }
}
