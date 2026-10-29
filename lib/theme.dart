import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna & tema Hiyote (palet hijau sage + krem hangat)
class AppColors {
  static const Color bg = Color(0xFFF7F3EC);
  static const Color surface = Color(0xFFFCFAF6);
  static const Color border = Color(0xFFE9E3D8);
  static const Color sage = Color(0xFF7A8B5C);
  static const Color sageLight = Color(0xFF8F9E6F);
  static const Color forest = Color(0xFF53613A);
  static const Color ink = Color(0xFF2A2E22);
  static const Color muted = Color(0xFF7C7F72);
  static const Color gold = Color(0xFFC9973A);
  static const Color danger = Color(0xFFC62828);
  static const Color low = Color(0xFF19B67A);
  static const Color mid = Color(0xFFF2C230);
  static const Color high = Color(0xFFE5445A);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.sage,
        primary: AppColors.sage,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );
    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );
  }

  /// Font serif untuk judul (Hiyote & judul catatan)
  static TextStyle serif({double size = 28, FontWeight weight = FontWeight.w600}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: weight,
        color: AppColors.ink,
      );
}

/// Dekorasi kotak input yang dipakai di banyak layar
BoxDecoration fieldBox({Color? color, double radius = 16}) => BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border),
    );
