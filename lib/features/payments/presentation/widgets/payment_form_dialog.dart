import 'package:flutter/material.dart';
import '../../../students/domain/entities/student.dart';
import '../../domain/entities/payment.dart';

/// Hem yeni ödeme ekleme hem de mevcut ödemeyi düzenleme için kullanılır.
class PaymentFormDialog extends StatefulWidget {
  final Payment? initialPayment;
  final List<Student> students;
  final void Function(
    int studentId,
    double amount,
    String period,
    DateTime dueDate,
  ) onSubmit;

  const PaymentFormDialog({
    super.key,
    this.initialPayment,
    required this.students,
    required this.onSubmit,
  });

  bool get isEditing => initialPayment != null;

  @override
  State<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _periodController;
  int? _selectedStudentId;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    final p = widget.initialPayment;
    _amountController = TextEditingController(
      text: p != null ? p.amount.toStringAsFixed(0) : '',
    );
    _periodController = TextEditingController(text: p?.period ?? '');
    _selectedStudentId =
        p?.studentId ?? (widget.students.isNotEmpty ? widget.students.first.id : null);
    _dueDate = p?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentId == null) return;
    widget.onSubmit(
      _selectedStudentId!,
      double.parse(_amountController.text.trim().replaceAll(',', '.')),
      _periodController.text.trim(),
      _dueDate,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Ödemeyi Düzenle' : 'Yeni Ödeme Ekle'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedStudentId,
                decoration: const InputDecoration(labelText: 'Öğrenci'),
                items: widget.students
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Text('${s.fullName} · ${s.classLevel.label}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedStudentId = value),
                validator: (v) => v == null ? 'Öğrenci seçin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Tutar',
                  suffixText: '₺',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Tutar zorunlu';
                  final parsed = double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Geçerli bir tutar girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _periodController,
                decoration: const InputDecoration(
                  labelText: 'Dönem',
                  hintText: 'Örn: Ocak 2026',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Dönem zorunlu' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vade: ${_dueDate.day.toString().padLeft(2, '0')}.'
                      '${_dueDate.month.toString().padLeft(2, '0')}.${_dueDate.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: const Text('Tarih Seç'),
                  ),
                ],
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
          onPressed: widget.students.isEmpty ? null : _submit,
          child: Text(widget.isEditing ? 'Kaydet' : 'Ekle'),
        ),
      ],
    );
  }
}
