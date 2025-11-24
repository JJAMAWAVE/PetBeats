import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';

class ModeDetailView extends GetView<HomeController> {
  const ModeDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modeName = Get.arguments?['modeName'] ?? 'Unknown Mode';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
        title: Text(modeName, style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // 파형 애니메이션 (임시)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.graphic_eq,
                  size: 100,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '현재 재생 중',
                style: AppTextStyles.body.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '60 BPM • Deep Sleep',
                style: AppTextStyles.title.copyWith(fontSize: 24),
              ),
              const Spacer(),
              // 하트비트 싱크 설정
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lineLightBlue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.redAccent),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('하트비트 싱크', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        Text('진동으로 심박수 동기화', style: AppTextStyles.body.copyWith(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    Obx(() => Switch(
                      value: controller.isHeartbeatSyncEnabled.value,
                      onChanged: controller.toggleHeartbeatSync,
                      activeColor: AppColors.primaryBlue,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // 재생 컨트롤
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 48, color: AppColors.textDarkNavy),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 24),
                  Obx(() => Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                            size: 48,
                            color: Colors.white,
                          ),
                          onPressed: controller.togglePlay,
                        ),
                      )),
                  const SizedBox(width: 24),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 48, color: AppColors.textDarkNavy),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
