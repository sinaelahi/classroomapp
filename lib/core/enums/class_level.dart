/// Dershanedeki sabit sınıf seviyeleri listesi.
/// Yeni bir seviye eklemek/çıkarmak istersen sadece bu enum'u güncellemen yeterli.
enum ClassLevel {
  sinif5('5. Sınıf'),
  sinif6('6. Sınıf'),
  sinif7('7. Sınıf'),
  sinif8('8. Sınıf (LGS)'),
  sinif9('9. Sınıf'),
  sinif10('10. Sınıf'),
  sinif11('11. Sınıf'),
  sinif12('12. Sınıf (YKS)'),
  mezun('Mezun');

  final String label;
  const ClassLevel(this.label);

  static ClassLevel fromName(String name) {
    return ClassLevel.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ClassLevel.sinif5,
    );
  }
}
