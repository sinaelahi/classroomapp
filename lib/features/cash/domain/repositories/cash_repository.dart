import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/cash_transaction.dart';
import '../entities/cash_summary.dart';

abstract class CashRepository {
  Future<Either<Failure, List<CashTransaction>>> getTransactions();
  Future<Either<Failure, CashTransaction>> addTransaction(
    CashTransaction transaction,
  );
  Future<Either<Failure, CashTransaction>> updateTransaction(
    CashTransaction transaction,
  );
  Future<Either<Failure, void>> deleteTransaction(int id);
  Future<Either<Failure, CashSummary>> getSummary();
}
