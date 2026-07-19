enum Gender {
  male('Erkek'),
  female('Kız');

  final String label;
  const Gender(this.label);

  static Gender fromName(String name) {
    return Gender.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Gender.male,
    );
  }
}
