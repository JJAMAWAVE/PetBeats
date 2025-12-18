import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

/// 통일된 닫기 버튼 위젯
/// 
/// 모든 뷰에서 동일한 스타일로 사용
/// - 라이트 모드: 32x32, 원형, 투명 배경, 다크 아이콘
/// - 다크 모드: 32x32, 원형, 반투명 흰색 배경, 흰색 아이콘
class CloseButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDarkMode;
  
  const CloseButtonWidget({
    super.key,
    this.onPressed,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: isDarkMode ? Colors.white70 : AppColors.textDarkNavy,
          size: 20.sp,
        ),
      ),
    );
  }
}
