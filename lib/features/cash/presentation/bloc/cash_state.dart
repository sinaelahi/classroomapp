import 'package:equatable/equatable.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/entities/cash_transaction.dart';

enum CashStatus { initial, loading, success, failure }

class CashState extends Equatable {
  final CashStatus status;
  final List<CashTransaction> transactions;
  final CashSummary summary;
  final String? errorMessage;

  const CashState({
    this.status = CashStatus.initial,
    this.transactions = const [],
    this.summary = const CashSummary.empty(),
    this.errorMessage,
  });

  CashState copyWith({
    CashStatus? status,
    List<CashTransaction>? transactions,
    CashSummary? summary,
    String? errorMessage,
  }) {
    return CashState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, summary, errorMessage];
}
