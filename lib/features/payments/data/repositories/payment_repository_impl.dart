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
      double paid = 0, unpaid = 0, upcoming = 0;
      int paidCount = 0, unpaidCount = 0, upcomingCount = 0;

      for (final row in rows) {
        final status = PaymentStatus.fromName(row.status);
        switch (status) {
          case PaymentStatus.paid:
            paid += row.amount;
            paidCount++;
            break;
          case PaymentStatus.unpaid:
            unpaid += row.amount;
            unpaidCount++;
            break;
          case PaymentStatus.upcoming:
            upcoming += row.amount;
            upcomingCount++;
            break;
        }
      }

      return Right(
        PaymentSummary(
          totalPaidAmount: paid,
          totalUnpaidAmount: unpaid,
          totalUpcomingAmount: upcoming,
          paidCount: paidCount,
          unpaidCount: unpaidCount,
          upcomingCount: upcomingCount,
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure('Özet hesaplanırken hata oluştu: $e'));
    }
  }
}
