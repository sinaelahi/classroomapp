import 'package:fpdart/fpdart.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

/// Bir ödemeyi "ödendi" olarak işaretler ve ödeme tarihini bugüne set eder.
class MarkAsPaid implements UseCase<Payment, Payment> {
  final PaymentRepository repository;
  const MarkAsPaid(this.repository);

  @override
  Future<Either<Failure, Payment>> call(Payment params) {
    final updated = params.copyWith(
      status: PaymentStatus.paid,
      paidDate: DateTime.now(),
    );
    return repository.updatePayment(updated);
  }
}
