import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/data/theme_local_datasource.dart';
import 'package:miniapp/notification/notification_bloc.dart';
import 'package:miniapp/presentation/auth_bloc.dart';
import 'package:miniapp/presentation/auth_gate.dart';
import 'package:miniapp/presentation/student/student_bloc.dart';
import 'package:miniapp/presentation/student/student_event.dart';
import 'package:miniapp/student_list_page.dart';
import 'package:miniapp/data/student_local_datasource.dart';
import 'package:miniapp/theme/theme_bloc.dart';
import 'package:miniapp/theme/theme_event.dart';
import 'package:miniapp/theme/theme_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       
        BlocProvider(create: (_) => AuthBloc()),

        
        BlocProvider(
          create: (_) =>
              StudentBloc(StudentLocalDatasource())..add(LoadStudents()),
        ),

        BlocProvider(create: (_) => NotificationBloc()),

       
        BlocProvider(
          create: (_) => ThemeBloc(ThemeLocalDatasource())..add(LoadTheme()),
        ),
      ],

      
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Aplikasi Siswa',

            themeMode: themeState.themeMode,

            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.light,
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
            ),

            home: const AuthGate(),

            routes: {'/students': (_) => const StudentListPage()},
          );
        },
      ),
    );
  }
}
