import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../../app/data/services/haptic_service.dart';

class SpeciesToggle extends GetView<HomeController> {
  const SpeciesToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.transparent, width: 2), // Transparent border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final tabs = controller.speciesTabs;
        if (tabs.isEmpty) return const SizedBox.shrink();

        return Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            return _buildToggleItem(
              index,
              tab.label,
              tab.iconPath,
            );
          }),
        );
      }),
    );
  }

  Widget _buildToggleItem(int index, String label, String iconPath) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedSpeciesIndex.value == index;
        return GestureDetector(
          onTap: () {
            Get.find<HapticService>().lightImpact();
            controller.changeSpecies(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ] : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    decoration: isSelected ? BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ) : null,
                    child: Image.asset(
                      iconPath,
                      width: 48, // 2x original size (24 -> 48)
                      height: 48,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
