import 'package:flutter/material.dart';
import '../../../../core/enums/class_level.dart';
import '../../../../core/enums/gender.dart';
import '../../domain/entities/student.dart';

/// Hem yeni öğrenci ekleme hem de mevcut öğrenciyi düzenleme için kullanılır.
/// [initialStudent] verilirse "düzenleme" modunda açılır.
class StudentFormDialog extends StatefulWidget {
  final Student? initialStudent;
  final void Function(
    String firstName,
    String lastName,
    String phoneNumber,
    ClassLevel classLevel,
    Gender gender,
  ) onSubmit;

  const StudentFormDialog({
    super.key,
    this.initialStudent,
    required this.onSubmit,
  });

  bool get isEditing => initialStudent != null;

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late ClassLevel _selectedLevel;
  late Gender _selectedGender;

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;
    _firstNameController = TextEditingController(text: s?.firstName ?? '');
    _lastNameController = TextEditingController(text: s?.lastName ?? '');
    _phoneController = TextEditingController(text: s?.phoneNumber ?? '');
    _selectedLevel = s?.classLevel ?? ClassLevel.starter;
    _selectedGender = s?.gender ?? Gender.male;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _phoneController.text.trim(),
      _selectedLevel,
      _selectedGender,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Öğrenciyi Düzenle' : 'Yeni Öğrenci Ekle'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<Gender>(
                segments: const [
                  ButtonSegment(
                    value: Gender.male,
                    label: Text('Erkek'),
                    icon: Icon(Icons.male_rounded),
                  ),
                  ButtonSegment(
                    value: Gender.female,
                    label: Text('Kız'),
                    icon: Icon(Icons.female_rounded),
                  ),
                ],
                selected: {_selectedGender},
                onSelectionChanged: (selection) =>
                    setState(() => _selectedGender = selection.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ad zorunlu' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Soyad'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Soyad zorunlu' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  hintText: '05xx xxx xx xx',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Telefon zorunlu';
                  final digits = v.replaceAll(RegExp(r'\D'), '');
                  if (digits.length < 10) return 'Geçerli bir numara girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ClassLevel>(
                value: _selectedLevel,
                decoration: const InputDecoration(labelText: 'Sınıf Seviyesi'),
                items: ClassLevel.values
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(level.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedLevel = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.isEditing ? 'Kaydet' : 'Ekle'),
        ),
      ],
    );
  }
}
