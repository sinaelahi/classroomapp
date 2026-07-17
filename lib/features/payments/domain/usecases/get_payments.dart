import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPayments implements UseCase<List<Payment>, NoParams> {
  final PaymentRepository repository;
  const GetPayments(this.repository);

  @override
  Future<Either<Failure, List<Payment>>> call(NoParams params) {
    return repository.getPayments();
  }
}
