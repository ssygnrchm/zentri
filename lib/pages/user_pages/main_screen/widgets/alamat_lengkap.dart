import 'package:flutter/material.dart';
import 'package:zentri/utils/colors/app_colors.dart';

Widget buildAlamatLengkap({
  required String jalan,
  required String kelurahan,
  required String kecamatan,
  required String kota,
  required String provinsi,
  required String negara,
  required String kodePos,
}) {
  TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  TextStyle valueStyle = TextStyle(color: AppColors.textSecondary);

  Widget buildItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Text(label, style: labelStyle),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(value.isNotEmpty ? value : "-", style: valueStyle),
        ),
        SizedBox(height: 10),
        Divider(color: AppColors.border),
        SizedBox(height: 6),
      ],
    );
  }

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildItem(icon: Icons.location_on, label: "Jalan", value: jalan),
        buildItem(icon: Icons.home_work, label: "Kelurahan", value: kelurahan),
        buildItem(icon: Icons.map, label: "Kecamatan", value: kecamatan),
        buildItem(icon: Icons.location_city, label: "Kota", value: kota),
        buildItem(icon: Icons.terrain, label: "Provinsi", value: provinsi),
        buildItem(icon: Icons.flag, label: "Negara", value: negara),
        buildItem(icon: Icons.mail, label: "Kode Pos", value: kodePos),
      ],
    ),
  );
}
