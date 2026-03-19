import 'package:flutter/material.dart';

/// Paleta de cores do Kronos.
///
/// Construída em torno de dois pilares:
/// - **Violeta profundo** — concentração, profundidade, o peso do tempo (Kronos).
/// - **Teal/menta** — frescor, progresso, sessões concluídas com sucesso.
///
/// O tema escuro é a experiência principal (ambiente de foco, sem distrações).
abstract final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────────────

  /// Violeta primário — identidade visual do Kronos.
  static const Color violet = Color(0xFF6C5CE7);

  /// Versão mais clara para uso sobre fundos escuros.
  static const Color violetLight = Color(0xFF9D93EF);

  /// Container do primário no tema escuro.
  static const Color violetContainer = Color(0xFF2D2560);

  /// Teal — cor de acento, representa progresso e sessões ativas.
  static const Color teal = Color(0xFF00C9A7);

  /// Versão mais clara para uso sobre fundos escuros.
  static const Color tealLight = Color(0xFF33DDBB);

  /// Container do secundário no tema escuro.
  static const Color tealContainer = Color(0xFF003D33);

  // ── Escala de escuros ──────────────────────────────────────────────────────

  static const Color bgDark = Color(0xFF0C0C15);
  static const Color surfaceDark = Color(0xFF12121E);
  static const Color surfaceDim = Color(0xFF0C0C15);
  static const Color surfaceContainerLowestDark = Color(0xFF0E0E19);
  static const Color surfaceContainerLowDark = Color(0xFF16162A);
  static const Color surfaceContainerDark = Color(0xFF1B1B2E);
  static const Color surfaceContainerHighDark = Color(0xFF212134);
  static const Color surfaceContainerHighestDark = Color(0xFF27273C);
  static const Color outlineDark = Color(0xFF3A3A55);
  static const Color outlineVariantDark = Color(0xFF252540);

  // ── Escala de claros ───────────────────────────────────────────────────────

  static const Color bgLight = Color(0xFFF4F4FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowLight = Color(0xFFEEEEFB);
  static const Color surfaceContainerLight = Color(0xFFE8E8F5);
  static const Color surfaceContainerHighLight = Color(0xFFE2E2EF);
  static const Color surfaceContainerHighestLight = Color(0xFFDCDCE9);
  static const Color outlineLight = Color(0xFFB0B0CC);
  static const Color outlineVariantLight = Color(0xFFD4D4EE);

  // ── Semânticas ─────────────────────────────────────────────────────────────

  static const Color error = Color(0xFFFF4D6D);
  static const Color errorContainer = Color(0xFF5C001E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFFFD9E1);

  static const Color success = Color(0xFF00C9A7);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF5BA4CF);

  // ── Texto ──────────────────────────────────────────────────────────────────

  static const Color onSurfaceDark = Color(0xFFE8E8FF);
  static const Color onSurfaceVariantDark = Color(0xFFB0AECF);
  static const Color onSurfaceLight = Color(0xFF1A1A2E);
  static const Color onSurfaceVariantLight = Color(0xFF4A4A6A);
}
