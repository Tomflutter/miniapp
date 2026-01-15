import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitted(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class LogoutRequested extends AuthEvent {}