import 'package:equatable/equatable.dart';

/// Dashboard/ödemeler ekranında gösterilecek toplam özet.
class PaymentSummary extends Equatable {
  /// Şimdiye kadar fiilen tahsil edilen toplam tutar (tam + kısmi ödemeler
  /// dahil — her ödemenin paidAmount'unun toplamı).
  final double totalPaidAmount;

  /// Durumu "Ödenmedi" olan ödemelerin toplam tutarı.
  final double totalUnpaidAmount;

  /// Durumu "Ödenecek" (henüz vadesi gelmemiş) ödemelerin toplam tutarı.
  final double totalUpcomingAmount;

  /// Kısmi ödenmiş kayıtların henüz tahsil edilmemiş kalan kısmı.
  final double totalPartialRemainingAmount;

  final int paidCount;
  final int unpaidCount;
  final int upcomingCount;
  final int partialCount;

  const PaymentSummary({
    required this.totalPaidAmount,
    required this.totalUnpaidAmount,
    required this.totalUpcomingAmount,
    required this.totalPartialRemainingAmount,
    required this.paidCount,
    required this.unpaidCount,
    required this.upcomingCount,
    required this.partialCount,
  });

  const PaymentSummary.empty()
      : totalPaidAmount = 0,
        totalUnpaidAmount = 0,
        totalUpcomingAmount = 0,
        totalPartialRemainingAmount = 0,
        paidCount = 0,
        unpaidCount = 0,
        upcomingCount = 0,
        partialCount = 0;

  @override
  List<Object?> get props => [
        totalPaidAmount,
        totalUnpaidAmount,
        totalUpcomingAmount,
        totalPartialRemainingAmount,
        paidCount,
        unpaidCount,
        upcomingCount,
        partialCount,
      ];
}
