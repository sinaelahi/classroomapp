import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cash_summary.dart';
import '../repositories/cash_repository.dart';

class GetCashSummary implements UseCase<CashSummary, NoParams> {
  final CashRepository repository;
  const GetCashSummary(this.repository);

  @override
  Future<Either<Failure, CashSummary>> call(NoParams params) {
    return repository.getSummary();
  }
}
