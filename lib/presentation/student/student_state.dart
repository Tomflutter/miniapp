import 'package:equatable/equatable.dart';
import 'package:miniapp/data/student_model.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoaded extends StudentState {
  final List<StudentModel> students;
  StudentLoaded(this.students);

  @override
  List<Object?> get props => [students];
}
