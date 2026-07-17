import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../entities/payment_summary.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<Payment>>> getPayments();
  Future<Either<Failure, List<Payment>>> getPaymentsByStudent(int studentId);
  Future<Either<Failure, Payment>> addPayment(Payment payment);
  Future<Either<Failure, Payment>> updatePayment(Payment payment);
  Future<Either<Failure, void>> deletePayment(int id);
  Future<Either<Failure, PaymentSummary>> getPaymentSummary();
}
