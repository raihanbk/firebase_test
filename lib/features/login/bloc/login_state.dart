part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

final class LoginInitial extends LoginState {}

class LoginActionState extends LoginState {}

class LoginLoadedState extends LoginState {}

class LoginSuccessStateActionState extends LoginActionState {}

class LoginErrorActionState extends LoginActionState {}
