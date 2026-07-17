import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class UpdatePayment implements UseCase<Payment, Payment> {
  final PaymentRepository repository;
  const UpdatePayment(this.repository);

  @override
  Future<Either<Failure, Payment>> call(Payment params) {
    return repository.updatePayment(params);
  }
}
