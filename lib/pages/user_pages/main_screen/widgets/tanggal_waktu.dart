import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zentri/utils/colors/app_colors.dart';

Container showTanggalWaktu(BuildContext context) {
  return Container(
    child: Center(
      child: StreamBuilder<DateTime>(
        stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
        builder: (context, snapshot) {
          final now = snapshot.data ?? DateTime.now();

          final formattedDate = DateFormat("EEEE, d MMMM yyyy").format(now);
          final formattedTime = DateFormat("HH:mm:ss").format(now);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Current Time',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
