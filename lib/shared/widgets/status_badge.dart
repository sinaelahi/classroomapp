import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/payment_status.dart';

class StatusBadge extends StatelessWidget {
  final PaymentStatus status;
  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case PaymentStatus.paid:
        return AppColors.paid;
      case PaymentStatus.unpaid:
        return AppColors.unpaid;
      case PaymentStatus.upcoming:
        return AppColors.upcoming;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
