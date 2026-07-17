import 'package:equatable/equatable.dart';

/// Dashboard/ödemeler ekranında gösterilecek toplam özet.
class PaymentSummary extends Equatable {
  final double totalPaidAmount;
  final double totalUnpaidAmount;
  final double totalUpcomingAmount;
  final int paidCount;
  final int unpaidCount;
  final int upcomingCount;

  const PaymentSummary({
    required this.totalPaidAmount,
    required this.totalUnpaidAmount,
    required this.totalUpcomingAmount,
    required this.paidCount,
    required this.unpaidCount,
    required this.upcomingCount,
  });

  const PaymentSummary.empty()
      : totalPaidAmount = 0,
        totalUnpaidAmount = 0,
        totalUpcomingAmount = 0,
        paidCount = 0,
        unpaidCount = 0,
        upcomingCount = 0;

  @override
  List<Object?> get props => [
        totalPaidAmount,
        totalUnpaidAmount,
        totalUpcomingAmount,
        paidCount,
        unpaidCount,
        upcomingCount,
      ];
}
