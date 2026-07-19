import 'package:flutter/material.dart';
import '../../domain/entities/cash_transaction.dart';

/// Hem yeni gelir/gider ekleme hem de mevcut kaydı düzenleme için kullanılır.
class CashTransactionFormDialog extends StatefulWidget {
  final CashTransaction? initialTransaction;
  final void Function(
    String title,
    double amount,
    CashType type,
    DateTime date,
  ) onSubmit;

  const CashTransactionFormDialog({
    super.key,
    this.initialTransaction,
    required this.onSubmit,
  });

  bool get isEditing => initialTransaction != null;

  @override
  State<CashTransactionFormDialog> createState() =>
      _CashTransactionFormDialogState();
}

class _CashTransactionFormDialogState
    extends State<CashTransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late CashType _selectedType;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTransaction;
    _titleController = TextEditingController(text: t?.title ?? '');
    _amountController = TextEditingController(
      text: t != null ? t.amount.toStringAsFixed(0) : '',
    );
    _selectedType = t?.type ?? CashType.expense;
    _selectedDate = t?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _titleController.text.trim(),
      double.parse(_amountController.text.trim().replaceAll(',', '.')),
      _selectedType,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Kaydı Düzenle' : 'Yeni Gelir / Gider'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<CashType>(
                segments: const [
                  ButtonSegment(
                    value: CashType.income,
                    label: Text('Gelir'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                  ButtonSegment(
                    value: CashType.expense,
                    label: Text('Gider'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (selection) =>
                    setState(() => _selectedType = selection.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  hintText: 'Örn: Kitap alımı, Ocak kirası',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Açıklama zorunlu' : null,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tarih: ${_selectedDate.day.toString().padLeft(2, '0')}.'
                      '${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
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
          onPressed: _submit,
          child: Text(widget.isEditing ? 'Kaydet' : 'Ekle'),
        ),
      ],
    );
  }
}
