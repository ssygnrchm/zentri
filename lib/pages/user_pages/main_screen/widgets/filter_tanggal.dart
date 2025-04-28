import 'package:flutter/material.dart';
import 'package:zentri/services/providers/widget_provider.dart';
import 'package:zentri/utils/colors/app_colors.dart';

GestureDetector datePicker(
  BuildContext context,
  WidgetProvider wProv,
  TextEditingController selectedDate,
  String title,
) {
  return GestureDetector(
    onTap: () {
      wProv.pickDate(context, selectedDate);
    },
    child: AbsorbPointer(
      child: TextField(
        controller: selectedDate,
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          label: Text(title),
          labelStyle: TextStyle(color: AppColors.textPrimary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}
