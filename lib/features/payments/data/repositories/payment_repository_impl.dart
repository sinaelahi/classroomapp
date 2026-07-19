import 'package:fpdart/fpdart.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_summary.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource localDataSource;
  const PaymentRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Payment>>> getPayments() async {
    try {
      final rows = await localDataSource.getPayments();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Ödemeler yüklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByStudent(
    int studentId,
  ) async {
    try {
      final rows = await localDataSource.getPaymentsByStudent(studentId);
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Ödemeler yüklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, Payment>> addPayment(Payment payment) async {
    try {
      final row = await localDataSource.addPayment(payment.toCompanion());
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Ödeme eklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePayment(Payment payment) async {
    try {
      final row = await localDataSource.updatePayment(
        payment.id!,
        payment.toCompanion(),
      );
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Ödeme güncellenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePayment(int id) async {
    try {
      await localDataSource.deletePayment(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Ödeme silinirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentSummary>> getPaymentSummary() async {
    try {
      final rows = await localDataSource.getPayments();
      double totalPaid = 0;
      double unpaid = 0;
      double upcoming = 0;
      double partialRemaining = 0;
      int paidCount = 0, unpaidCount = 0, upcomingCount = 0, partialCount = 0;

      for (final row in rows) {
        final status = PaymentStatus.fromName(row.status);
        // Fiilen tahsil edilen tutar — durumdan bağımsız, her zaman sayılır.
        totalPaid += row.paidAmount;

        switch (status) {
          case PaymentStatus.paid:
            paidCount++;
            break;
          case PaymentStatus.partial:
            partialRemaining += (row.amount - row.paidAmount).clamp(0, row.amount);
            partialCount++;
            break;
          case PaymentStatus.unpaid:
            unpaid += row.amount - row.paidAmount;
            unpaidCount++;
            break;
          case PaymentStatus.upcoming:
            upcoming += row.amount - row.paidAmount;
            upcomingCount++;
            break;
        }
      }

      return Right(
        PaymentSummary(
          totalPaidAmount: totalPaid,
          totalUnpaidAmount: unpaid,
          totalUpcomingAmount: upcoming,
          totalPartialRemainingAmount: partialRemaining,
          paidCount: paidCount,
          unpaidCount: unpaidCount,
          upcomingCount: upcomingCount,
          partialCount: partialCount,
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure('Özet hesaplanırken hata oluştu: $e'));
    }
  }
}
