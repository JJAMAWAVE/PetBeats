import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_dimensions.dart';

/// 표준 페이지 헤더 위젯
/// 
/// 앱 전체에서 일관된 헤더 레이아웃 적용
class PageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool centerTitle;

  const PageHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: 16.h,
      ),
      color: backgroundColor ?? Colors.transparent,
      child: Row(
        children: [
          // 뒤로가기 버튼
          if (showBackButton)
            GestureDetector(
              onTap: onBackPressed ?? () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: titleColor ?? AppColors.textDarkNavy,
                  size: 20.sp,
                ),
              ),
            ),
          
          if (showBackButton) SizedBox(width: 16.w),

          // 제목
          if (centerTitle)
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: titleColor ?? AppColors.textDarkNavy,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: titleColor ?? AppColors.textDarkNavy,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // 액션 버튼들
          if (actions != null) ...[
            SizedBox(width: 16.w),
            ...actions!.map((action) => Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: action,
            )),
          ],
        ],
      ),
    );
  }
}

/// 다크 테마용 페이지 헤더
class DarkPageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const DarkPageHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: 16.h,
      ),
      color: Colors.transparent,
      child: Row(
        children: [
          // 뒤로가기 버튼
          if (showBackButton)
            GestureDetector(
              onTap: onBackPressed ?? () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          
          if (showBackButton) SizedBox(width: 16.w),

          // 제목
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 액션 버튼들
          if (actions != null) ...[
            SizedBox(width: 16.w),
            ...actions!.map((action) => Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: action,
            )),
          ],
        ],
      ),
    );
  }
}
