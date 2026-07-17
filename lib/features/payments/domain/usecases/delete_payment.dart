import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/payment_repository.dart';

class DeletePayment implements UseCase<void, int> {
  final PaymentRepository repository;
  const DeletePayment(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.deletePayment(params);
  }
}
