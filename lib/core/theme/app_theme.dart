import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

/// Tema central do Kronos.
///
/// Uso:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract final class AppTheme {
  static ThemeData get dark => _dark;
  static ThemeData get light => _light;

  // ─────────────────────────────────────────────────────────────────────────
  // ColorSchemes
  // ─────────────────────────────────────────────────────────────────────────

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // primary
    primary: AppColors.violetLight,
    onPrimary: Color(0xFF1A1240),
    primaryContainer: AppColors.violetContainer,
    onPrimaryContainer: Color(0xFFDDD8FF),
    // secondary
    secondary: AppColors.tealLight,
    onSecondary: Color(0xFF003328),
    secondaryContainer: AppColors.tealContainer,
    onSecondaryContainer: Color(0xFFB2FFE8),
    // tertiary — tom âmbar suave para avisos de "tempo esgotado"
    tertiary: Color(0xFFFFB347),
    onTertiary: Color(0xFF3A2800),
    tertiaryContainer: Color(0xFF5A3D00),
    onTertiaryContainer: Color(0xFFFFDFAA),
    // error
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    // surface
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    surfaceDim: AppColors.surfaceDim,
    surfaceContainerLowest: AppColors.surfaceContainerLowestDark,
    surfaceContainerLow: AppColors.surfaceContainerLowDark,
    surfaceContainer: AppColors.surfaceContainerDark,
    surfaceContainerHigh: AppColors.surfaceContainerHighDark,
    surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
    onSurfaceVariant: AppColors.onSurfaceVariantDark,
    // outline
    outline: AppColors.outlineDark,
    outlineVariant: AppColors.outlineVariantDark,
    // misc
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.bgLight,
    onInverseSurface: AppColors.onSurfaceLight,
    inversePrimary: AppColors.violet,
  );

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    // primary
    primary: AppColors.violet,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE4DFFF),
    onPrimaryContainer: Color(0xFF1D0F6B),
    // secondary
    secondary: Color(0xFF00A388),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFB2F2E4),
    onSecondaryContainer: Color(0xFF002920),
    // tertiary
    tertiary: Color(0xFFD4820A),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDFAA),
    onTertiaryContainer: Color(0xFF3A2800),
    // error
    error: Color(0xFFBA1A2A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD7),
    onErrorContainer: Color(0xFF410008),
    // surface
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    surfaceContainerLowest: AppColors.surfaceContainerLowestLight,
    surfaceContainerLow: AppColors.surfaceContainerLowLight,
    surfaceContainer: AppColors.surfaceContainerLight,
    surfaceContainerHigh: AppColors.surfaceContainerHighLight,
    surfaceContainerHighest: AppColors.surfaceContainerHighestLight,
    onSurfaceVariant: AppColors.onSurfaceVariantLight,
    // outline
    outline: AppColors.outlineLight,
    outlineVariant: AppColors.outlineVariantLight,
    // misc
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.surfaceDark,
    onInverseSurface: AppColors.onSurfaceDark,
    inversePrimary: AppColors.violetLight,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Typography
  // ─────────────────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      // Display — nome do app, contadores grandes de tempo
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        color: onSurface,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w300,
        letterSpacing: 0,
        color: onSurface,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: onSurface,
        height: 1.22,
      ),
      // Headline — títulos de secções, nome da sessão ativa
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: onSurface,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: onSurface,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
        height: 1.33,
      ),
      // Title — cabeçalhos de card, AppBar
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: onSurface,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: onSurface,
        height: 1.50,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
        height: 1.43,
      ),
      // Body — conteúdo geral
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: onSurface,
        height: 1.50,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: onSurface,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: onSurfaceVariant,
        height: 1.33,
      ),
      // Label — botões, chips, tabs
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onSurface,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: onSurfaceVariant,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: onSurfaceVariant,
        height: 1.45,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dark ThemeData
  // ─────────────────────────────────────────────────────────────────────────

  static final ThemeData _dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: AppColors.bgDark,
    textTheme: _buildTextTheme(
      AppColors.onSurfaceDark,
      AppColors.onSurfaceVariantDark,
    ),

    // ── AppBar ────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDark,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black54,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.bgDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.onSurfaceDark,
      ),
    ),

    // ── Card ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerDark,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black54,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.outlineVariantDark, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── ElevatedButton ────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.violetLight,
        foregroundColor: Color(0xFF1A1240),
        disabledBackgroundColor: AppColors.outlineVariantDark,
        disabledForegroundColor: AppColors.onSurfaceVariantDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── FilledButton ──────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.violetLight,
        foregroundColor: Color(0xFF1A1240),
        disabledBackgroundColor: AppColors.outlineVariantDark,
        disabledForegroundColor: AppColors.onSurfaceVariantDark,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── OutlinedButton ────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.violetLight,
        disabledForegroundColor: AppColors.onSurfaceVariantDark,
        side: BorderSide(color: AppColors.outlineDark),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── TextButton ────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.violetLight,
        disabledForegroundColor: AppColors.onSurfaceVariantDark,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── FloatingActionButton ──────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.tealLight,
      foregroundColor: AppColors.tealContainer,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // ── InputDecoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerHighDark,
      hoverColor: AppColors.surfaceContainerHighestDark,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.violetLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: TextStyle(color: AppColors.onSurfaceVariantDark, fontSize: 14),
      labelStyle: TextStyle(color: AppColors.onSurfaceVariantDark),
      floatingLabelStyle: TextStyle(color: AppColors.violetLight),
    ),

    // ── Chip ──────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHighDark,
      selectedColor: AppColors.violetContainer,
      disabledColor: AppColors.surfaceContainerDark,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceDark,
      ),
      secondaryLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.violetLight,
      ),
      side: BorderSide(color: AppColors.outlineVariantDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // ── NavigationBar (bottom) ────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceContainerLowDark,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black54,
      elevation: 0,
      indicatorColor: AppColors.violetContainer,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.violetLight
              : AppColors.onSurfaceVariantDark,
          size: 24,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.violetLight
              : AppColors.onSurfaceVariantDark,
        ),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // ── ProgressIndicator ─────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.violetLight,
      linearTrackColor: AppColors.surfaceContainerHighDark,
      circularTrackColor: AppColors.surfaceContainerHighDark,
      linearMinHeight: 6,
    ),

    // ── Divider ───────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariantDark,
      thickness: 1,
      space: 1,
    ),

    // ── Icon ──────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.onSurfaceVariantDark,
      size: 24,
    ),

    // ── ListTile ──────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: AppColors.onSurfaceVariantDark,
      textColor: AppColors.onSurfaceDark,
      subtitleTextStyle: TextStyle(
        fontSize: 13,
        color: AppColors.onSurfaceVariantDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // ── BottomSheet ───────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerLowDark,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.surfaceContainerLowDark,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────────────────────
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceContainerHighDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),

    // ── SnackBar ──────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceContainerHighestDark,
      contentTextStyle: const TextStyle(
        color: AppColors.onSurfaceDark,
        fontSize: 14,
      ),
      actionTextColor: AppColors.tealLight,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // ── Switch ────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.violetLight
            : AppColors.onSurfaceVariantDark,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.violetContainer
            : AppColors.surfaceContainerHighDark,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.transparent
            : AppColors.outlineDark,
      ),
    ),

    // ── Slider ────────────────────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.violetLight,
      inactiveTrackColor: AppColors.surfaceContainerHighDark,
      thumbColor: AppColors.violetLight,
      overlayColor: Color(0x299D93EF),
      valueIndicatorColor: AppColors.violetContainer,
      valueIndicatorTextStyle: TextStyle(color: AppColors.onSurfaceDark),
    ),

    // ── TabBar ────────────────────────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.violetLight,
      unselectedLabelColor: AppColors.onSurfaceVariantDark,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: AppColors.violetLight,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.outlineVariantDark,
    ),

    // ── PopupMenu ─────────────────────────────────────────────────────────
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.surfaceContainerHighDark,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      textStyle: TextStyle(color: AppColors.onSurfaceDark, fontSize: 14),
    ),

    // ── Tooltip ───────────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighestDark,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textStyle: const TextStyle(color: AppColors.onSurfaceDark, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Light ThemeData
  // ─────────────────────────────────────────────────────────────────────────

  static final ThemeData _light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: AppColors.bgLight,
    textTheme: _buildTextTheme(
      AppColors.onSurfaceLight,
      AppColors.onSurfaceVariantLight,
    ),

    // ── AppBar ────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgLight,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.onSurfaceLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bgLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: AppColors.onSurfaceLight,
      ),
    ),

    // ── Card ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.outlineVariantLight, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── ElevatedButton ────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.violet,
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── FilledButton ──────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.violet,
        foregroundColor: Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── OutlinedButton ────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.violet,
        side: BorderSide(color: AppColors.outlineLight),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── TextButton ────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.violet,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // ── FloatingActionButton ──────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.teal,
      foregroundColor: Color(0xFFFFFFFF),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // ── InputDecoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerHighLight,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.violet, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFBA1A2A)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFBA1A2A), width: 2),
      ),
      hintStyle: TextStyle(
        color: AppColors.onSurfaceVariantLight,
        fontSize: 14,
      ),
      labelStyle: TextStyle(color: AppColors.onSurfaceVariantLight),
      floatingLabelStyle: TextStyle(color: AppColors.violet),
    ),

    // ── Chip ──────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHighLight,
      selectedColor: Color(0xFFE4DFFF),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceLight,
      ),
      secondaryLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.violet,
      ),
      side: BorderSide(color: AppColors.outlineVariantLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // ── NavigationBar (bottom) ────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceContainerLowestLight,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      indicatorColor: Color(0xFFE4DFFF),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.violet
              : AppColors.onSurfaceVariantLight,
          size: 24,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.violet
              : AppColors.onSurfaceVariantLight,
        ),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // ── ProgressIndicator ─────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.violet,
      linearTrackColor: AppColors.surfaceContainerHighLight,
      circularTrackColor: AppColors.surfaceContainerHighLight,
      linearMinHeight: 6,
    ),

    // ── Divider ───────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariantLight,
      thickness: 1,
      space: 1,
    ),

    // ── Icon ──────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.onSurfaceVariantLight,
      size: 24,
    ),

    // ── ListTile ──────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: AppColors.onSurfaceVariantLight,
      textColor: AppColors.onSurfaceLight,
      subtitleTextStyle: TextStyle(
        fontSize: 13,
        color: AppColors.onSurfaceVariantLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // ── BottomSheet ───────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerLowestLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    // ── Dialog ────────────────────────────────────────────────────────────
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
    ),

    // ── SnackBar ──────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.onSurfaceLight,
      contentTextStyle: const TextStyle(
        color: AppColors.surfaceLight,
        fontSize: 14,
      ),
      actionTextColor: AppColors.tealLight,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // ── Switch ────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.violet
            : AppColors.onSurfaceVariantLight,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Color(0xFFE4DFFF)
            : AppColors.surfaceContainerHighLight,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.transparent
            : AppColors.outlineLight,
      ),
    ),

    // ── Slider ────────────────────────────────────────────────────────────
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.violet,
      inactiveTrackColor: AppColors.surfaceContainerHighLight,
      thumbColor: AppColors.violet,
      overlayColor: Color(0x296C5CE7),
      valueIndicatorColor: Color(0xFFE4DFFF),
      valueIndicatorTextStyle: TextStyle(color: AppColors.onSurfaceLight),
    ),

    // ── TabBar ────────────────────────────────────────────────────────────
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.violet,
      unselectedLabelColor: AppColors.onSurfaceVariantLight,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: AppColors.violet,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.outlineVariantLight,
    ),

    // ── PopupMenu ─────────────────────────────────────────────────────────
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      textStyle: TextStyle(color: AppColors.onSurfaceLight, fontSize: 14),
    ),

    // ── Tooltip ───────────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.onSurfaceLight,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textStyle: const TextStyle(color: AppColors.surfaceLight, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
  );
}
