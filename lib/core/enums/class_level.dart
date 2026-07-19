/// Dershane seviye sistemi.
/// Yeni bir seviye eklemek/çıkarmak istersen sadece bu enum'u güncellemen yeterli.
enum ClassLevel {
  starter('Starter'),
  family1('Family 1'),
  family2('Family 2'),
  family3('Family 3'),
  family4('Family 4'),
  family5('Family 5'),
  family6('Family 6'),
  americanExpress('American Express');

  final String label;
  const ClassLevel(this.label);

  static ClassLevel fromName(String name) {
    return ClassLevel.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ClassLevel.starter,
    );
  }
}
