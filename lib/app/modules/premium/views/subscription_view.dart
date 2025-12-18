import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/subscription_controller.dart';
import '../../../routes/app_routes.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: TextButton(
                  onPressed: () => controller.restorePurchases(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'premium_restore'.tr,
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: AppColors.textDarkNavy, size: 20.w),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    
                    // Value Proposition
                    Text(
                      'premium_title'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkNavy,
                        height: 1.3,
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Benefits
                    _buildBenefitRow(
                      Icons.music_note,
                      '90+',
                      'premium_benefit_1'.tr,
                    ),
                    SizedBox(height: 16.h),
                    _buildBenefitRow(
                      Icons.psychology,
                      'premium_benefit_sync'.tr,
                      'premium_benefit_2'.tr,
                    ),
                    SizedBox(height: 16.h),
                    _buildBenefitRow(
                      Icons.vibration,
                      'Haptic',
                      'premium_benefit_3'.tr,
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Plan Selector
                    Obx(() => Column(
                      children: [
                        _ShineEffect(
                          child: _buildPlanCard(
                            title: 'premium_plan_yearly'.tr,
                            price: '₩33,000',
                            priceDetail: 'premium_price_yearly'.tr,
                            discount: 'premium_discount_yearly'.tr,
                            isBest: true,
                            socialProof: 'premium_social_proof'.tr,
                            isSelected: controller.selectedPlan.value == SubscriptionPlan.yearly,
                            onTap: () => controller.selectPlan(SubscriptionPlan.yearly),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildPlanCard(
                          title: 'premium_plan_6months'.tr,
                          price: '₩19,900',
                          priceDetail: 'premium_price_6months'.tr,
                          discount: 'premium_discount_6months'.tr,
                          isSelected: controller.selectedPlan.value == SubscriptionPlan.halfYearly,
                          onTap: () => controller.selectPlan(SubscriptionPlan.halfYearly),
                        ),
                        SizedBox(height: 12.h),
                        _buildPlanCard(
                          title: 'premium_plan_3months'.tr,
                          price: '₩10,900',
                          priceDetail: 'premium_price_3months'.tr,
                          discount: 'premium_discount_3months'.tr,
                          isSelected: controller.selectedPlan.value == SubscriptionPlan.quarterly,
                          onTap: () => controller.selectPlan(SubscriptionPlan.quarterly),
                        ),
                        SizedBox(height: 12.h),
                        _buildPlanCard(
                          title: 'premium_plan_monthly'.tr,
                          price: '₩3,900',
                          priceDetail: 'premium_price_monthly'.tr,
                          discount: null,
                          isSelected: controller.selectedPlan.value == SubscriptionPlan.monthly,
                          onTap: () => controller.selectPlan(SubscriptionPlan.monthly),
                        ),
                      ],
                    )),
                    
                    SizedBox(height: 24.h),
                    
                    // Referral Nudge
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.INVITE_FRIENDS); 
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'premium_referral_title'.tr,
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.card_giftcard, size: 18.w, color: AppColors.primaryBlue),
                                SizedBox(width: 6.w),
                                Text(
                                  'premium_referral_action'.tr,
                                  style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.chevron_right, size: 18.w, color: AppColors.primaryBlue),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // CTA Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.startFreeTrial(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'premium_start_trial'.tr,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                    
                    SizedBox(height: 12.h),
                    
                    // Micro-copy
                    Text(
                      'premium_trial_desc'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textDarkNavy.withOpacity(0.6),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String highlight, String text) {
    return Row(
      children: [
        Icon(icon, size: 28.w, color: AppColors.primaryBlue),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textDarkNavy,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: highlight,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String priceDetail,
    String? discount,
    bool isBest = false,
    String? socialProof,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: isBest
                  ? const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFE55C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isBest ? null : (isSelected ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isBest
                    ? const Color(0xFFFFD700)
                    : (isSelected ? AppColors.primaryBlue : Colors.grey.shade300),
                width: isBest ? 2 : (isSelected ? 2 : 1),
              ),
              boxShadow: [
                if (isBest)
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Radio Button
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isBest ? Colors.white : (isSelected ? AppColors.primaryBlue : Colors.grey.shade400),
                      width: 2,
                    ),
                    color: isSelected
                        ? (isBest ? Colors.white : AppColors.primaryBlue)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isBest ? const Color(0xFFFFD700) : Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                
                // Plan Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isBest ? Colors.white : AppColors.textDarkNavy,
                            ),
                          ),
                          if (isBest) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'BEST',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // 가격 앵커링
                      Text(
                        priceDetail,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isBest ? Colors.white : AppColors.textDarkNavy,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${'total'.tr} $price',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isBest ? Colors.white.withOpacity(0.8) : AppColors.textGrey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Discount Badge
                if (discount != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isBest ? Colors.white.withOpacity(0.2) : AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      discount,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isBest ? Colors.white : AppColors.primaryBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Social Proof Badge
          if (socialProof != null)
            Positioned(
              top: -10.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.textDarkNavy,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  socialProof,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ShineEffect extends StatefulWidget {
  final Widget child;
  const _ShineEffect({required this.child});

  @override
  State<_ShineEffect> createState() => _ShineEffectState();
}

class _ShineEffectState extends State<_ShineEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                alignment: AlignmentGeometry.lerp(
                  Alignment.centerLeft - const Alignment(2.0, 0.0),
                  Alignment.centerRight + const Alignment(2.0, 0.0),
                  _controller.value,
                )!,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
