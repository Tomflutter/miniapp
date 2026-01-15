import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import '../../data/theme_local_datasource.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeLocalDatasource datasource;

  ThemeBloc(this.datasource) : super(const ThemeState(ThemeMode.light)) {
    on<LoadTheme>((event, emit) async {
      final isDark = await datasource.getTheme();
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    });

    on<ToggleTheme>((event, emit) async {
      final isDark = state.themeMode == ThemeMode.dark;
      await datasource.saveTheme(!isDark);
      emit(ThemeState(!isDark ? ThemeMode.dark : ThemeMode.light));
    });
  }
}
