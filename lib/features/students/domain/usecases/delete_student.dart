import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/student_repository.dart';

class DeleteStudent implements UseCase<void, int> {
  final StudentRepository repository;
  const DeleteStudent(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.deleteStudent(params);
  }
}
