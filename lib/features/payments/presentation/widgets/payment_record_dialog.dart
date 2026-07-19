import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/payment.dart';

/// "Ödeme Al" ekranı — kısmi ya da tam tahsilat kaydetmek için.
/// Öğrencinin borcunun tamamını değil, o an eline geçen tutarı girer;
/// birden fazla kısmi ödeme üst üste birikir.
class PaymentRecordDialog extends StatefulWidget {
  final Payment payment;
  final void Function(double amountReceived) onSubmit;

  const PaymentRecordDialog({
    super.key,
    required this.payment,
    required this.onSubmit,
  });

  @override
  State<PaymentRecordDialog> createState() => _PaymentRecordDialogState();
}

class _PaymentRecordDialogState extends State<PaymentRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    // Varsayılan olarak kalan tutarın tamamı önerilir — "tam öde" tek
    // dokunuşla mümkün olsun diye.
    _amountController = TextEditingController(
      text: widget.payment.remainingAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _fillFullRemaining() {
    setState(() {
      _amountController.text =
          widget.payment.remainingAmount.toStringAsFixed(0);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    widget.onSubmit(amount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    return AlertDialog(
      title: const Text('Ödeme Al'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                label: 'Toplam tutar',
                value: CurrencyFormatter.format(payment.amount),
              ),
              const SizedBox(height: 6),
              _InfoRow(
                label: 'Şimdiye kadar ödenen',
                value: CurrencyFormatter.format(payment.paidAmount),
              ),
              const SizedBox(height: 6),
              _InfoRow(
                label: 'Kalan',
                value: CurrencyFormatter.format(payment.remainingAmount),
                emphasize: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Bu ödemede alınan tutar',
                  suffixText: '₺',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Tutar zorunlu';
                  final parsed = double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Geçerli bir tutar girin';
                  if (parsed > payment.remainingAmount + 0.01) {
                    return 'Kalan tutardan fazla girilemez';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _fillFullRemaining,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Tam Öde (kalan tutarı doldur)'),
                ),
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
        FilledButton(onPressed: _submit, child: const Text('Kaydet')),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(
          value,
          style: AppTextStyles.figureSmall.copyWith(
            color: emphasize ? AppColors.coral : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
