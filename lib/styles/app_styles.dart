import 'package:flutter/material.dart';

/// 集中管理主題與樣式（等同 CSS）
class AppStyles {
  AppStyles._();

  /// 黑白主題（深色底、灰白階）
  static ThemeData get theme {
    const black = Color(0xFF121212);
    const surface = Color(0xFF1E1E1E);
    const onSurface = Color(0xFFE0E0E0);
    const outline = Color(0xFF616161);
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE0E0E0),
        onPrimary: Color(0xFF121212),
        primaryContainer: Color(0xFF2C2C2C),
        onPrimaryContainer: Color(0xFFE0E0E0),
        secondary: Color(0xFFB0B0B0),
        onSecondary: Color(0xFF121212),
        secondaryContainer: Color(0xFF383838),
        onSecondaryContainer: Color(0xFFE0E0E0),
        tertiary: Color(0xFF9E9E9E),
        onTertiary: Color(0xFF121212),
        tertiaryContainer: Color(0xFF424242),
        onTertiaryContainer: Color(0xFFE0E0E0),
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: Color(0xFF2C2C2C),
        onSurfaceVariant: Color(0xFFB0B0B0),
        outline: outline,
        inverseSurface: onSurface,
        onInverseSurface: black,
        inversePrimary: Color(0xFF2C2C2C),
      ),
      scaffoldBackgroundColor: black,
      cardTheme: CardThemeData(
        elevation: 2,
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static const EdgeInsets bodyPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(16);
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 24;

  /// 本局結果標題
  static TextStyle sectionTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          );

  /// 小節標題（出拳、依電腦出的手…）
  static TextStyle subsectionTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          );

  /// 結果文字顏色（黑白主題：贏亮、輸暗）
  static Color resultColor(String result, BuildContext context) {
    if (result == '你贏了') return const Color(0xFFE0E0E0);
    if (result == '你輸了') return const Color(0xFF757575);
    return Theme.of(context).colorScheme.onSurface;
  }

  /// 結果文字樣式（粗體 + 結果色）
  static TextStyle resultTextStyle(String result, BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: resultColor(result, context),
          );

  /// 標籤+數值用的小標
  static TextStyle labelStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;

  /// 標籤+數值的數值
  static TextStyle labelValueStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);

  /// 統計內文
  static TextStyle bodyMediumBold(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500);

  /// 統計列
  static EdgeInsets get statRowPadding => const EdgeInsets.symmetric(vertical: 4);

  /// 勝率顏色：高於 50% 綠、低於 50% 紅、等於或無數據用預設
  static Color rateColor(int wins, int losses, BuildContext context) {
    final total = wins + losses;
    if (total == 0) return Theme.of(context).colorScheme.onSurface;
    final rate = wins / total;
    if (rate > 0.5) return Colors.green.shade400;
    if (rate < 0.5) return Colors.red.shade400;
    return Theme.of(context).colorScheme.onSurface;
  }
}
