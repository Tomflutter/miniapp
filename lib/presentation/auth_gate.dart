import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/presentation/auth_bloc.dart';
import 'package:miniapp/presentation/auth_event.dart';
import 'package:miniapp/presentation/auth_state.dart';
import 'package:miniapp/login_page.dart';
import 'package:miniapp/student_list_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return const StudentListPage();
        }

        
        return const LoginPage();
      },
    );
  }
}
