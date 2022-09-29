import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class AuthOrPage extends StatelessWidget {
  final Widget page;

  const AuthOrPage({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoSignIn(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('An error has ocurred when signing. Try again later!'),
          );
        } else {
          return auth.isAuthenticated ? page : const AuthPage();
        }
      },
    );
  }
}
