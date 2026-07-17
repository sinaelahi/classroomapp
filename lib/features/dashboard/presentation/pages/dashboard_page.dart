import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/layouts/desktop_scaffold.dart';

/// Basit bir başlangıç panosu. Bir sonraki adımda öğrenci/ödeme
/// istatistiklerini burada özetleyeceğiz.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      currentRoute: '/',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Panel', style: AppTextStyles.heading1),
            const SizedBox(height: 8),
            const Text(
              'Öğrenci ve ödeme özetleri burada gösterilecek.',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
