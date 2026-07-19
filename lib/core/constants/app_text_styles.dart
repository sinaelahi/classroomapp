import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tip ölçeği: Sora (başlık) + Inter (gövde) + IBM Plex Mono (para/rakam).
class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: AppColors.ink,
      );

  static TextStyle get heading2 => GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.ink,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.ink,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  /// Para/miktar rakamları için — "defter" hissi veren mono tipografi.
  static TextStyle get figure => GoogleFonts.ibmPlexMono(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
        letterSpacing: -0.5,
      );

  static TextStyle get figureSmall => GoogleFonts.ibmPlexMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );
}
