import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cash_transaction.dart';
import '../repositories/cash_repository.dart';

class UpdateTransaction implements UseCase<CashTransaction, CashTransaction> {
  final CashRepository repository;
  const UpdateTransaction(this.repository);

  @override
  Future<Either<Failure, CashTransaction>> call(CashTransaction params) {
    return repository.updateTransaction(params);
  }
}
