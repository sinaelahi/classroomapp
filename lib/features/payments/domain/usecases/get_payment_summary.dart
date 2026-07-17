import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_summary.dart';
import '../repositories/payment_repository.dart';

class GetPaymentSummary implements UseCase<PaymentSummary, NoParams> {
  final PaymentRepository repository;
  const GetPaymentSummary(this.repository);

  @override
  Future<Either<Failure, PaymentSummary>> call(NoParams params) {
    return repository.getPaymentSummary();
  }
}
