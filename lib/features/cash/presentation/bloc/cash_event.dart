import 'package:equatable/equatable.dart';
import '../../domain/entities/cash_transaction.dart';

abstract class CashEvent extends Equatable {
  const CashEvent();
  @override
  List<Object?> get props => [];
}

class LoadCashTransactions extends CashEvent {
  const LoadCashTransactions();
}

class AddCashTransactionRequested extends CashEvent {
  final String title;
  final double amount;
  final CashType type;
  final DateTime date;

  const AddCashTransactionRequested({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  List<Object?> get props => [title, amount, type, date];
}

class UpdateCashTransactionRequested extends CashEvent {
  final CashTransaction transaction;
  const UpdateCashTransactionRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteCashTransactionRequested extends CashEvent {
  final int id;
  const DeleteCashTransactionRequested(this.id);

  @override
  List<Object?> get props => [id];
}
