import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onus2_flutter/providers/auth_provider.dart';
import 'package:onus2_flutter/views/auth/auth_screen.dart';
import 'package:onus2_flutter/views/main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.status == AuthStatus.uninitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.status == AuthStatus.authenticated) {
      return const MainScreen();
    }

    return const AuthScreen();
  }
}
