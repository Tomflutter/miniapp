import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniapp/data/student_local_datasource.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentLocalDatasource datasource;

  StudentBloc(this.datasource) : super(StudentInitial()) {
    on<AddStudent>(_onAddStudent);
    on<LoadStudents>(_onLoadStudents);
    on<RefreshStudents>(_onRefreshStudents);
  }

  Future<void> _onAddStudent(
    AddStudent event,
    Emitter<StudentState> emit,
  ) async {
    await datasource.saveStudent(event.student);
    final students = await datasource.getStudents();
    emit(StudentLoaded(students));
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<StudentState> emit,
  ) async {
    final students = await datasource.getStudents();
    emit(StudentLoaded(students));
  }

  Future<void> _onRefreshStudents(
    RefreshStudents event,
    Emitter<StudentState> emit,
  ) async {
    final students = await datasource.getStudents();
    emit(StudentLoaded(students));
  }
}
