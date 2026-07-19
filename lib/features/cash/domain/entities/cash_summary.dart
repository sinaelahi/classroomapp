import 'package:equatable/equatable.dart';

/// Kasa özeti: toplam gelir, toplam gider ve bakiye (gelir - gider).
class CashSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;

  const CashSummary({required this.totalIncome, required this.totalExpense});

  const CashSummary.empty() : totalIncome = 0, totalExpense = 0;

  double get balance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [totalIncome, totalExpense];
}
