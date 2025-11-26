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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(32),
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
              tab.icon,
            );
          }),
        );
      }),
    );
  }

  Widget _buildToggleItem(int index, String label, IconData icon) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedSpeciesIndex.value == index;
        return GestureDetector(
          onTap: () {
            Get.find<HapticService>().lightImpact();
            controller.changeSpecies(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? AppColors.primaryBlue : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primaryBlue : Colors.grey,
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
