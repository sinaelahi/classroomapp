import 'package:equatable/equatable.dart';
import '../../domain/entities/student.dart';

enum StudentStatus { initial, loading, success, failure }

class StudentState extends Equatable {
  final StudentStatus status;
  final List<Student> students;
  final String? errorMessage;

  const StudentState({
    this.status = StudentStatus.initial,
    this.students = const [],
    this.errorMessage,
  });

  StudentState copyWith({
    StudentStatus? status,
    List<Student>? students,
    String? errorMessage,
  }) {
    return StudentState(
      status: status ?? this.status,
      students: students ?? this.students,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, students, errorMessage];
}
