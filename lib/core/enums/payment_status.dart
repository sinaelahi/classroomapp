/// Bir ödemenin durumu: ödendi / ödenmedi / ödenecek (yaklaşan).
enum PaymentStatus {
  paid('Ödendi'),
  unpaid('Ödenmedi'),
  upcoming('Ödenecek');

  final String label;
  const PaymentStatus(this.label);

  static PaymentStatus fromName(String name) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => PaymentStatus.upcoming,
    );
  }
}
