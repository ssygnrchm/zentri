import 'package:flutter/material.dart';
import 'package:zentri/utils/colors/app_colors.dart';
import 'package:zentri/utils/styles/app_btn_style.dart';

class CustomDialog {
  void loading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan tap di luar
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.accent),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Mohon tunggu...",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void message(BuildContext context, {required String pesan}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pesan),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: AppBtnStyle.normal,
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void hide(BuildContext context) {
    Navigator.of(context).pop(); // Menutup dialog
  }
}
