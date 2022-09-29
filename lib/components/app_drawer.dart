import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Welcome User!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.orders,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.products,
            ),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Sign Out'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).signOut();
              Navigator.of(context).pushReplacementNamed(AppRoutes.authOrHome);
            },
          ),
        ],
      ),
    );
  }
}
