import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class AddPaymentParams extends Equatable {
  final int studentId;
  final double amount;
  final String period;
  final DateTime dueDate;

  const AddPaymentParams({
    required this.studentId,
    required this.amount,
    required this.period,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [studentId, amount, period, dueDate];
}

class AddPayment implements UseCase<Payment, AddPaymentParams> {
  final PaymentRepository repository;
  const AddPayment(this.repository);

  @override
  Future<Either<Failure, Payment>> call(AddPaymentParams params) {
    final payment = Payment(
      studentId: params.studentId,
      amount: params.amount,
      period: params.period,
      dueDate: params.dueDate,
      status: PaymentStatus.upcoming,
    );
    return repository.addPayment(payment);
  }
}
