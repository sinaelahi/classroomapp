import 'package:flutter/material.dart';

/// Fare üzerine gelince hafifçe yukarı kalkan ve gölgesi belirginleşen
/// sarmalayıcı. Özet kartları ve liste satırları için kullanılıyor.
class HoverLift extends StatefulWidget {
  final Widget child;
  final double liftPx;

  const HoverLift({super.key, required this.child, this.liftPx = 3});

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _hovering ? -widget.liftPx : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
