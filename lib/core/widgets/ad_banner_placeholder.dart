import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/modules/home/controllers/home_controller.dart';

class AdBannerPlaceholder extends GetView<HomeController> {
  const AdBannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPremiumUser.value) {
        return const SizedBox.shrink(); // 프리미엄 유저는 광고 숨김
      }
      return Container(
        height: 60,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Center(
          child: Text('AdMob Banner Placeholder'),
        ),
      );
    });
  }
}
