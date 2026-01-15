import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckAuth);
    on<LoginSubmitted>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  
  Future<void> _onCheckAuth(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  
  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {

    await Future.delayed(const Duration(seconds: 1));

    if (event.username == 'admin' && event.password == '123456') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Username atau password salah"));
    }
  }

  
  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); 

    emit(AuthInitial());
  }
}
