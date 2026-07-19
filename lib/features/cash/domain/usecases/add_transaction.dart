import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cash_transaction.dart';
import '../repositories/cash_repository.dart';

class AddTransactionParams extends Equatable {
  final String title;
  final double amount;
  final CashType type;
  final DateTime date;

  const AddTransactionParams({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  List<Object?> get props => [title, amount, type, date];
}

class AddTransaction
    implements UseCase<CashTransaction, AddTransactionParams> {
  final CashRepository repository;
  const AddTransaction(this.repository);

  @override
  Future<Either<Failure, CashTransaction>> call(AddTransactionParams params) {
    final transaction = CashTransaction(
      title: params.title,
      amount: params.amount,
      type: params.type,
      date: params.date,
    );
    return repository.addTransaction(transaction);
  }
}
