import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color inkBlack = Color(0xFF0C1618);
  static const Color brandy = Color(0xFF772F1A);
  static const Color seaweed = Color(0xFF21A179);
  static const Color jasmine = Color(0xFFF4D58D);
  static const Color canvasBg = Color(0xFFEFF1ED);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color subtleFill = Color(0xFFF1F3F5);
  static const Color borderSubtle = Color(0xFFDCE0D9);
  static const Color borderStrong = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF52606D);

  static const Color pivotBg = jasmine;
  static const Color pivotBorder = inkBlack;
  static const Color pivotText = inkBlack;
  static final Color sourceRowBg = seaweed.withValues(alpha: 0.14);
  static final Color sourceRowBorder = seaweed.withValues(alpha: 0.45);
  static final Color targetRowBg = brandy.withValues(alpha: 0.11);
  static final Color targetRowBorder = brandy.withValues(alpha: 0.40);
  static const Color statusUnique = seaweed;
  static const Color statusInfinite = jasmine;
  static const Color statusNoSolution = brandy;

  static const TextStyle matrixNumberStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: inkBlack,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle inputNumberStyle = TextStyle(
    fontSize: 16.5,
    fontWeight: FontWeight.w700,
    color: inkBlack,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: inkBlack,
      onPrimary: Colors.white,
      secondary: seaweed,
      onSecondary: Colors.white,
      tertiary: jasmine,
      onTertiary: inkBlack,
      error: brandy,
      onError: Colors.white,
      surface: surfaceWhite,
      onSurface: inkBlack,
      outline: borderStrong,
      outlineVariant: borderSubtle,
    );

    final textTheme = const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.25,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.25,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: inkBlack,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: inkBlack,
        height: 1.35,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: inkBlack,
        height: 1.35,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: inkBlack,
        height: 1.35,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: inkBlack,
        height: 1.45,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: inkBlack,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textMuted,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: inkBlack,
        height: 1.35,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textMuted,
        height: 1.35,
      ),
      labelSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textMuted,
        height: 1.35,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvasBg,
      canvasColor: canvasBg,
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          side: BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: inkBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seaweed,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkBlack,
          backgroundColor: surfaceWhite,
          side: const BorderSide(color: borderStrong, width: 1.2),
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brandy,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return inkBlack;
            }
            return surfaceWhite;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return inkBlack;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: borderStrong, width: 1.2),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: subtleFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        hintStyle: const TextStyle(fontSize: 13, color: textMuted),
        labelStyle: const TextStyle(fontSize: 13, color: textMuted),
        floatingLabelStyle: const TextStyle(fontSize: 13, color: seaweed),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderStrong, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderStrong, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: seaweed, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brandy, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brandy, width: 1.5),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: seaweed,
        inactiveTrackColor: borderSubtle,
        thumbColor: inkBlack,
        overlayColor: seaweed.withValues(alpha: 0.14),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return seaweed;
          }
          return borderSubtle;
        }),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: inkBlack,
          hoverColor: inkBlack.withValues(alpha: 0.06),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
