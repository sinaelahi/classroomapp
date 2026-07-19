import 'package:equatable/equatable.dart';
import '../../../../core/enums/class_level.dart';
import '../../../../core/enums/gender.dart';
import '../../domain/entities/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object?> get props => [];
}

class LoadStudents extends StudentEvent {
  const LoadStudents();
}

class AddStudentRequested extends StudentEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final ClassLevel classLevel;
  final Gender gender;

  const AddStudentRequested({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.classLevel,
    required this.gender,
  });

  @override
  List<Object?> get props =>
      [firstName, lastName, phoneNumber, classLevel, gender];
}

class UpdateStudentRequested extends StudentEvent {
  final Student student;
  const UpdateStudentRequested(this.student);

  @override
  List<Object?> get props => [student];
}

class DeleteStudentRequested extends StudentEvent {
  final int id;
  const DeleteStudentRequested(this.id);

  @override
  List<Object?> get props => [id];
}
