import 'package:flutter/material.dart';
import 'package:zentri/models/user_model.dart';
import 'package:zentri/pages/user_pages/main_screen/widgets/profile_sheet.dart';
import 'package:zentri/services/providers/profile_provider.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';
import 'package:zentri/utils/colors/app_colors.dart';

Widget dashboardHeader(
  BuildContext context,
  ProfileProvider profileProv,
  Data profile,
) {
  bool isLoadProfile = profileProv.isLoading;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isLoadProfile
            ? CircleAvatar(
              backgroundColor: AppColors.primary,
              child: CircularProgressIndicator(color: AppColors.border),
            )
            : GestureDetector(
              onTap: () {
                showProfileSheet(
                  context,
                  profileProv,
                  name: profile.name!,
                  email: profile.email!,
                  createdAt: profile.createdAt!,
                  updatedAt: profile.updatedAt!,
                );
              },
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: AppColors.background),
              ),
            ),
        const Text(
          'Zentri',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            PrefsHandler.removeToken();
            Navigator.pushReplacementNamed(context, "/login");
          },
          child: const Icon(Icons.logout),
        ),
      ],
    ),
  );
}
