import 'package:flutter/material.dart';
import 'package:zentri/utils/colors/app_colors.dart';

class AppBtnStyle {
  // Elevation and shadow constants
  static const double _elevation = 0.0;
  static const double _cornerRadius = 8.0;
  static const double _paddingVertical = 16.0;

  // Text styling
  static const TextStyle _buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Base button style that all others extend from
  static final ButtonStyle _baseStyle = ElevatedButton.styleFrom(
    elevation: _elevation,
    padding: const EdgeInsets.symmetric(vertical: _paddingVertical),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cornerRadius),
    ),
    textStyle: _buttonTextStyle,
  );

  // Primary button - standard
  static ButtonStyle normal = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.primary.withOpacity(0.5);
      }
      return AppColors.primary;
    }),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  // Primary button - small/compact
  static ButtonStyle normalS = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(AppColors.primary),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
  );

  // Primary button - bold text
  static ButtonStyle normalBold = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(AppColors.primary),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    textStyle: MaterialStateProperty.all(
      _buttonTextStyle.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  // Success button (green)
  static ButtonStyle hijau = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(AppColors.success),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  // Warning button (red)
  static ButtonStyle merah = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(AppColors.warning),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  // Accent button (blue)
  static ButtonStyle biru = _baseStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(AppColors.accent),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  // Outlined variant - minimalist style
  static ButtonStyle outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: _paddingVertical),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cornerRadius),
    ),
    side: BorderSide(color: AppColors.primary, width: 1.5),
    textStyle: _buttonTextStyle,
  );

  // Text button variant - ultra minimalist
  static ButtonStyle text = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    textStyle: _buttonTextStyle,
  );
}
