import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/auth.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
import 'pages/auth_or_page.dart';
import 'pages/auth_page.dart';
import 'pages/cart_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/product_form_page.dart';
import 'pages/products_overview_page.dart';
import 'pages/products_page.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (_) => Cart(),
          update: (ctx, auth, previous) {
            return Cart(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? {},
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.pink[900],
                secondary: Colors.white,
                tertiary: Colors.black87,
              ),
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                centerTitle: true,
              ),
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.authOrHome: (_) => const AuthOrPage(
                page: ProductsOverviewPage(),
              ),
          AppRoutes.productsOverview: (_) =>
              const AuthOrPage(page: ProductsOverviewPage()),
          AppRoutes.productDetail: (_) =>
              const AuthOrPage(page: ProductDetailPage()),
          AppRoutes.cart: (_) => const AuthOrPage(page: CartPage()),
          AppRoutes.orders: (_) => const AuthOrPage(page: OrdersPage()),
          AppRoutes.products: (_) => const AuthOrPage(page: ProductsPage()),
          AppRoutes.productForm: (_) =>
              const AuthOrPage(page: ProductFormPage()),
        },
      ),
    );
  }
}
