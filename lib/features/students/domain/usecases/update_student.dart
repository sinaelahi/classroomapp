import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

class UpdateStudent implements UseCase<Student, Student> {
  final StudentRepository repository;
  const UpdateStudent(this.repository);

  @override
  Future<Either<Failure, Student>> call(Student params) {
    return repository.updateStudent(params);
  }
}
