import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cash_transaction.dart';
import '../repositories/cash_repository.dart';

class GetTransactions implements UseCase<List<CashTransaction>, NoParams> {
  final CashRepository repository;
  const GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<CashTransaction>>> call(NoParams params) {
    return repository.getTransactions();
  }
}
