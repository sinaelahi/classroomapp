import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/entities/cash_transaction.dart';
import '../../domain/repositories/cash_repository.dart';
import '../datasources/cash_local_datasource.dart';
import '../models/cash_transaction_model.dart';

class CashRepositoryImpl implements CashRepository {
  final CashLocalDataSource localDataSource;
  const CashRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CashTransaction>>> getTransactions() async {
    try {
      final rows = await localDataSource.getTransactions();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Kasa hareketleri yüklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, CashTransaction>> addTransaction(
    CashTransaction transaction,
  ) async {
    try {
      final row = await localDataSource.addTransaction(transaction.toCompanion());
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Kasa hareketi eklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, CashTransaction>> updateTransaction(
    CashTransaction transaction,
  ) async {
    try {
      final row = await localDataSource.updateTransaction(
        transaction.id!,
        transaction.toCompanion(),
      );
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Kasa hareketi güncellenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(int id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Kasa hareketi silinirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, CashSummary>> getSummary() async {
    try {
      final rows = await localDataSource.getTransactions();
      double income = 0;
      double expense = 0;
      for (final row in rows) {
        if (CashType.fromName(row.type) == CashType.income) {
          income += row.amount;
        } else {
          expense += row.amount;
        }
      }
      return Right(CashSummary(totalIncome: income, totalExpense: expense));
    } catch (e) {
      return Left(DatabaseFailure('Kasa özeti hesaplanırken hata oluştu: $e'));
    }
  }
}
