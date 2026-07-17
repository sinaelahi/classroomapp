import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<Student>>> getStudents();
  Future<Either<Failure, Student>> getStudentById(int id);
  Future<Either<Failure, Student>> addStudent(Student student);
  Future<Either<Failure, Student>> updateStudent(Student student);
  Future<Either<Failure, void>> deleteStudent(int id);
}
