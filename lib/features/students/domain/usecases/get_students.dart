import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/student.dart';
import '../repositories/student_repository.dart';

class GetStudents implements UseCase<List<Student>, NoParams> {
  final StudentRepository repository;
  const GetStudents(this.repository);

  @override
  Future<Either<Failure, List<Student>>> call(NoParams params) {
    return repository.getStudents();
  }
}
