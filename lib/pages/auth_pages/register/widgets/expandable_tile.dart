import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zentri/services/providers/widget_provider.dart';
import 'package:zentri/utils/colors/app_colors.dart';

Widget buildExpandableField(
  BuildContext context, {
  required int index,
  required String label,
  required IconData icon,
  required TextEditingController controller,
  required bool isFilled,
  bool obscureText = false,
}) {
  final prov = Provider.of<WidgetProvider>(context);
  int? expandedField = prov.expandedField;

  final bool isExpanded = expandedField == index;

  return GestureDetector(
    onTap: () => prov.toggleExpand(index),

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFilled ? Colors.white : AppColors.warning,
        border: Border.all(
          color: isExpanded ? AppColors.accent : AppColors.border,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            isExpanded
                ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isFilled ? AppColors.textSecondary : Colors.white,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isFilled ? AppColors.textSecondary : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              onChanged: (value) {
                prov.setFilledStatus(index: index, value: value.isNotEmpty);
              },
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: 'Masukkan $label',
                hintStyle: TextStyle(
                  color: isFilled ? AppColors.textSecondary : Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
