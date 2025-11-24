import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_colors.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const PetBeatsApp());
}

class PetBeatsApp extends StatelessWidget {
  const PetBeatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PetBeats',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        primaryColor: AppColors.primaryBlue,
        useMaterial3: true,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
