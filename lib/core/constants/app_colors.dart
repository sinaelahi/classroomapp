import 'package:flutter/material.dart';

/// Tasarım paleti: "çalışma masası + defter" hissi.
/// Indigo marka rengi, amber sınıf/dikkat vurgusu, mint/coral finansal durum.
class AppColors {
  static const ink = Color(0xFF14161B);
  static const paper = Color(0xFFF7F8FB);
  static const surface = Color(0xFFFFFFFF);

  static const indigo = Color(0xFF3B4CCA);
  static const indigoDark = Color(0xFF2C39A0);
  static const indigoSoft = Color(0xFFEEF0FD);

  static const amber = Color(0xFFF5A623);
  static const amberSoft = Color(0xFFFDF1DC);

  static const mint = Color(0xFF1FAA76);
  static const mintSoft = Color(0xFFE3F5EE);

  static const coral = Color(0xFFE5484D);
  static const coralSoft = Color(0xFFFCE8E9);

  // Geriye dönük takma adlar (mevcut widget'lar bunları kullanıyor).
  static const primary = indigo;
  static const background = paper;
  static const textPrimary = ink;
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE7E8F0);

  static const paid = mint;
  static const unpaid = coral;
  static const upcoming = amber;
}
