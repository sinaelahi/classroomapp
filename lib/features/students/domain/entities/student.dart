import 'package:equatable/equatable.dart';
import '../../../../core/enums/class_level.dart';
import '../../../../core/enums/gender.dart';

class Student extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final ClassLevel classLevel;
  final Gender gender;
  final DateTime createdAt;

  const Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.classLevel,
    required this.gender,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  Student copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    ClassLevel? classLevel,
    Gender? gender,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      classLevel: classLevel ?? this.classLevel,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, phoneNumber, classLevel, gender, createdAt];
}
