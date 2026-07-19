import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cash_repository.dart';

class DeleteTransaction implements UseCase<void, int> {
  final CashRepository repository;
  const DeleteTransaction(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.deleteTransaction(params);
  }
}
