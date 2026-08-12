import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoStarColors {
  final bool isDark;

  const CoStarColors(this.isDark);

  Color get bg => isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFFFFFF);
  Color get background => bg;
  Color get cardBg => isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
  Color get surface => cardBg;
  Color get border => isDark ? const Color(0xFF262626) : const Color(0xFFE0E0E0);
  Color get borderStrong => isDark ? const Color(0xFF404040) : const Color(0xFF000000);
  Color get textPrimary => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  Color get textSecondary => isDark ? const Color(0xFFA0A0A0) : const Color(0xFF555555);
  Color get textMuted => isDark ? const Color(0xFF666666) : const Color(0xFF888888);
  Color get btnBg => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  Color get btnText => isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  static CoStarColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CoStarColors(isDark);
  }
}

class CoStarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFF5F5F5),
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFFFFFFFF)),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFFFFFFFF)),
      colorScheme: const ColorScheme.light(
        surface: Color(0xFFF5F5F5),
        primary: Color(0xFF000000),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF555555),
        outline: Color(0xFFE0E0E0),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          color: const Color(0xFF555555),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.spaceGrotesk(
          color: const Color(0xFF888888),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
      dividerColor: const Color(0xFFE0E0E0),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      cardColor: const Color(0xFF121212),
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0A0A0A)),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFF0A0A0A)),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF121212),
        primary: Color(0xFFFFFFFF),
        onPrimary: Color(0xFF0A0A0A),
        secondary: Color(0xFFA0A0A0),
        outline: Color(0xFF262626),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          color: const Color(0xFFA0A0A0),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.spaceGrotesk(
          color: const Color(0xFF666666),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
      dividerColor: const Color(0xFF262626),
    );
  }
}
