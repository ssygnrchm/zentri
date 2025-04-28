import 'package:flutter/material.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/tanggal_waktu.dart';
import 'package:zentri/utils/colors/app_colors.dart';

Widget welcomeSection(BuildContext context, String name) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Hello, $name",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        showTanggalWaktu(context),
      ],
    ),
  );
}
