import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_test/db/auth_db.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) async {
    final user = await Controller.handleSignIn(
        email: event.email, password: event.password);
    if (user != null) {
      print('Login Success');
      emit(LoginSuccessStateActionState());
    } else {
      print('Login Failed');
    }
  }
}
