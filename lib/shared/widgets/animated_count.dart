import 'package:flutter/material.dart';

/// Bir rakamın 0'dan hedef değere doğru "sayarak" belirmesini sağlar.
/// Özet kartlarındaki tutarlar için kullanılıyor — ağır bir animasyon
/// paketine ihtiyaç duymadan, Flutter'ın yerleşik TweenAnimationBuilder'ı ile.
class AnimatedCount extends StatelessWidget {
  final double value;
  final String Function(double) formatter;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCount({
    super.key,
    required this.value,
    required this.formatter,
    this.style,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Text(formatter(animatedValue), style: style);
      },
    );
  }
}
