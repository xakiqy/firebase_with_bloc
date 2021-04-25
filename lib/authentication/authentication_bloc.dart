import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in_bloc/repository/auth_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {

    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();

    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();

    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutInToState();
    }
  }

  //AuthenticationLoggedOut
  Stream<AuthenticationState> _mapAuthenticationLoggedOutInToState() async* {
    yield AuthenticationFailure();
    _authRepository.signOut();
  }

  //AuthenticationLoggedIn
  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess((await _authRepository
        .getUser())!); //TODO THINK ABOUT BETTER NULL CHECK
  }

  // AuthenticationStarted
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _authRepository.getUser();
      yield AuthenticationSuccess(firebaseUser!);
    } else {
      yield AuthenticationFailure();
    }
  }
}
