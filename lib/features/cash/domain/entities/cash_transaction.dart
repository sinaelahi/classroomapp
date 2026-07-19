import 'package:equatable/equatable.dart';

enum CashType {
  income('Gelir'),
  expense('Gider');

  final String label;
  const CashType(this.label);

  static CashType fromName(String name) {
    return CashType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => CashType.expense,
    );
  }
}

class CashTransaction extends Equatable {
  final int? id;
  final String title;
  final double amount;
  final CashType type;
  final DateTime date;

  const CashTransaction({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  CashTransaction copyWith({
    int? id,
    String? title,
    double? amount,
    CashType? type,
    DateTime? date,
  }) {
    return CashTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, type, date];
}
