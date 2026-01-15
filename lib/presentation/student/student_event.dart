import 'package:equatable/equatable.dart';
import 'package:miniapp/data/student_model.dart';

abstract class StudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddStudent extends StudentEvent {
  final StudentModel student;
  AddStudent(this.student);

  @override
  List<Object?> get props => [student];
}

class LoadStudents extends StudentEvent {}


class RefreshStudents extends StudentEvent {}
