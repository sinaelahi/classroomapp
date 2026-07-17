import 'package:equatable/equatable.dart';
import '../../../../core/enums/class_level.dart';

class Student extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final ClassLevel classLevel;
  final DateTime createdAt;

  const Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.classLevel,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  Student copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    ClassLevel? classLevel,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      classLevel: classLevel ?? this.classLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, phoneNumber, classLevel, createdAt];
}
