import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPaymentsByStudent implements UseCase<List<Payment>, int> {
  final PaymentRepository repository;
  const GetPaymentsByStudent(this.repository);

  @override
  Future<Either<Failure, List<Payment>>> call(int studentId) {
    return repository.getPaymentsByStudent(studentId);
  }
}
