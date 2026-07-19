import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/enums/class_level.dart';
import '../../../../core/enums/gender.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

class AddStudentParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final ClassLevel classLevel;
  final Gender gender;

  const AddStudentParams({
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

class AddStudent implements UseCase<Student, AddStudentParams> {
  final StudentRepository repository;
  const AddStudent(this.repository);

  @override
  Future<Either<Failure, Student>> call(AddStudentParams params) {
    final student = Student(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      classLevel: params.classLevel,
      gender: params.gender,
      createdAt: DateTime.now(),
    );
    return repository.addStudent(student);
  }
}
