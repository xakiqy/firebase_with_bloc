import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in_bloc/authentication/authentication_nav.dart';
import 'package:google_sign_in_bloc/repository/auth_repository.dart';

import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'authentication/authentication_state.dart';
import 'login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  runApp(FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyApp();
        } else if (snapshot.hasError) {
          return Center(child: Text("App requires internet"));
        }
        return Center(child: CircularProgressIndicator());
      }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
          create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => AuthenticationBloc(authRepository: context.read<AuthRepository>()),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if(state is AuthenticationInitial) {
                context.read<AuthenticationBloc>().add(AuthenticationStarted());
                return Center(child: CircularProgressIndicator());
              }

              if (state is AuthenticationFailure) {
                return AuthNavigator();
              }

              if (state is AuthenticationSuccess) {
                return HomeScreen(
                  user: state.firebaseUser,
                );
              }

              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  child: Center(child: Text("Loading")),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text("Hello, ${user.email}"),
          ),
          Center(
            child: Text("Verified, ${user.emailVerified}"),
          ),
          Center(
            child: Text("Phone Number, ${user.phoneNumber}"),
          ),
          Center(
            child: Text("UID, ${user.uid}"),
          ),
        ],
      ),
    );
  }
}
