import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:unifor_mobile/utils/meta_theme_color.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _scaffoldColor = const Color(0xFFE4F2FD);

  ThemeMode get themeMode => _themeMode;
  Color get scaffoldColor => _scaffoldColor;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setScaffoldColor(Color color) {
    _scaffoldColor = color;

    // Ignora o update da theme-color se for branco ou cinza claro
    if (_isIgnoredColor(color)) {
      debugPrint('Ignorando theme-color para: ${colorToHex(color)}');
      notifyListeners();
      return;
    }

    final amount = getDarkenAmount(color);
    final hex = colorToHex(darkenColor(color, amount));
    debugPrint('Atualizando theme-color para: $hex');

    if (kIsWeb) {
      updateThemeColor(hex);
    }

    notifyListeners();
  }
}

String colorToHex(Color color) {
  final rgb = color.value & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0')}';
}

Color darkenColor(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

double getDarkenAmount(Color color) {
  final luminance = color.computeLuminance(); // de 0.0 (preto) a 1.0 (branco)
  if (luminance > 0.9) return 0.3; // escurece bastante se muito clara
  if (luminance > 0.7) return 0.2;
  return 0.1;
}

bool _isIgnoredColor(Color color) {
  final hex = colorToHex(color).toLowerCase();
  return hex == '#ffffff' || hex == '#f5f5f5';
}
