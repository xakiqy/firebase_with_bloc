import 'package:flutter/material.dart';
import 'package:google_sign_in_bloc/login/login_screen.dart';
import 'package:google_sign_in_bloc/register/register_screen.dart';
import 'package:google_sign_in_bloc/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/': (context) =>
              LoginScreen(authRepository: context.read<AuthRepository>()),
          '/signUp': (context) =>
              RegisterScreen(authRepository: context.read<AuthRepository>()),
          // '/confirm': (context) => ConfirmationView()
        },
        initialRoute: '/'
    );
  }
}