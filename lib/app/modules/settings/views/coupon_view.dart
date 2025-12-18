import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/coupon_service.dart';

/// 쿠폰 등록 및 멤버십 관리 화면
class CouponView extends StatefulWidget {
  const CouponView({super.key});

  @override
  State<CouponView> createState() => _CouponViewState();
}

class _CouponViewState extends State<CouponView> {
  final _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponService = Get.find<CouponService>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text('coupon_title'.tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 A: 내 구독 현황 카드
            _buildStatusCard(couponService),
            SizedBox(height: 24.h),
            
            // 섹션 B: 쿠폰 코드 입력
            _buildCouponInput(couponService),
            SizedBox(height: 32.h),
            
            // 섹션 C: 등록 내역
            _buildHistorySection(couponService),
          ],
        ),
      ),
    );
  }

  /// 섹션 A: 내 구독 현황 카드
  Widget _buildStatusCard(CouponService couponService) {
    return Obx(() {
      final isPro = couponService.isPro;
      final expiryDate = couponService.proExpiryDate.value;
      final remainingDays = couponService.proRemainingDays;
      
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPro 
                ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                : [const Color(0xFF64748B), const Color(0xFF94A3B8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (isPro ? const Color(0xFF6366F1) : Colors.grey).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상태 배지
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPro ? Icons.workspace_premium : Icons.person_outline,
                        color: Colors.white,
                        size: 16.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        isPro ? 'coupon_pro_active'.tr : 'coupon_pro_inactive'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isPro)
                  Icon(
                    Icons.verified,
                    color: Colors.amber,
                    size: 28.w,
                  ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // 만료일 또는 업그레이드 안내
            if (isPro && expiryDate != null) ...[
              Text(
                'coupon_expires_on'.trParams({
                  'date': DateFormat('yyyy.MM.dd').format(expiryDate),
                }),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: Colors.white70, size: 18.w),
                  SizedBox(width: 6.w),
                  Text(
                    'coupon_days_remaining'.trParams({'days': remainingDays.toString()}),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'coupon_upgrade_prompt'.tr,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () => Get.toNamed('/subscription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF6366F1),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'premium_subscribe_btn'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// 섹션 B: 쿠폰 코드 입력
  Widget _buildCouponInput(CouponService couponService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'coupon_input_title'.tr,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        
        Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
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
                // 입력 필드
                TextFormField(
                  controller: _couponController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'coupon_input_placeholder'.tr,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.confirmation_number_outlined,
                      color: AppColors.primaryBlue,
                      size: 22.w,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.paste, color: Colors.grey.shade400),
                      onPressed: () async {
                        final data = await Clipboard.getData('text/plain');
                        if (data?.text != null) {
                          _couponController.text = data!.text!;
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                
                // 등록 버튼
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _couponController.text.trim().isEmpty || couponService.isLoading.value
                          ? null
                          : () => _registerCoupon(couponService),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: couponService.isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'coupon_register_btn'.tr,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 8.h),
        Text(
          'coupon_input_hint'.tr,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  /// 쿠폰 등록 처리
  Future<void> _registerCoupon(CouponService couponService) async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    
    final result = await couponService.registerCoupon(code);
    
    if (result.success) {
      _couponController.clear();
      setState(() {});
    } else {
      Get.snackbar(
        '❌ ${'coupon_error'.tr}',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// 섹션 C: 등록 내역
  Widget _buildHistorySection(CouponService couponService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'coupon_history_title'.tr,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        
        Obx(() {
          final coupons = couponService.registeredCoupons;
          
          if (coupons.isEmpty) {
            return Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      color: Colors.grey.shade300,
                      size: 48.w,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'coupon_no_history'.tr,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // 오픈 기념 7일 무료 시작하기 CTA
                    if (!couponService.isPro)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '🎉 오픈 기념 특별 혜택',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ElevatedButton(
                              onPressed: () => Get.toNamed('/subscription'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF6366F1),
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                '7일 무료로 시작하기',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          
          return Column(
            children: coupons.map((coupon) => _buildHistoryItem(coupon)).toList(),
          );
        }),
      ],
    );
  }

  /// 등록 내역 아이템
  Widget _buildHistoryItem(Coupon coupon) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '+${coupon.value}일 | ${DateFormat('yyyy.MM.dd').format(coupon.registeredAt)}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
