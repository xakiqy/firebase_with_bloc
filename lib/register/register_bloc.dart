
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in_bloc/register/register_event.dart';
import 'package:google_sign_in_bloc/register/register_state.dart';
import 'package:google_sign_in_bloc/repository/auth_repository.dart';
import 'package:google_sign_in_bloc/utils/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {required String email, required String password}) async* {
    yield RegisterState.loading();
    try {
      await _authRepository.signUp(email, password);
      yield RegisterState.success();
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        yield RegisterState.failureWeakPass();
      } else yield RegisterState.failure();
    } catch (e) {
      print(e);
    }
  }
}
