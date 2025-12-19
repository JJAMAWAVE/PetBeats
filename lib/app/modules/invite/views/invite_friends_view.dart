import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/invite_controller.dart';
import '../../../../app/data/services/haptic_service.dart';

class InviteFriendsView extends GetView<InviteController> {
  const InviteFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final hapticService = Get.find<HapticService>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 메인 콘텐츠
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // 이미지 1: 페이지 가장 위 (Invite Friends_1.png)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        'assets/images/InviteFriend/invite_friends_1.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 메인 헤드라인
                  _buildHeadline(),
                  
                  const SizedBox(height: 40),
                  
                  // 진행 상황
                  _buildProgress(),
                  
                  const SizedBox(height: 24),
                  
                  // 이미지 2: 0/3 Friends Joined 바로 밑 (Invite Friends_2.png)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        'assets/images/InviteFriend/invite_friends_2.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 보상 카드
                  _buildRewardCards(),
                  
                  const SizedBox(height: 24),
                  
                  // 이미지 3: 프리미엄 1개월 무료 구독 바로 밑 (Invite Friends_3.png)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        'assets/images/InviteFriend/invite_friends_3.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 참여 방법
                  _buildHowItWorks(),
                  
                  const SizedBox(height: 32),
                  
                  // 유의 사항
                  _buildFinePrint(),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
            
            // 상단 닫기 버튼
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  hapticService.lightImpact();
                  Get.back();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textDarkNavy,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // 하단 CTA 버튼
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomCTA(hapticService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'invite_headline'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkNavy,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'invite_headline_desc'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${controller.friendsJoined.value}',
                  style: GoogleFonts.notoSans(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  ' / ${InviteController.tier3Goal}',
                  style: GoogleFonts.notoSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'invite_friends_joined'.trParams({'count': controller.friendsJoined.value.toString()}),
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
                letterSpacing: 1.2,
              ),
            ),
            if (!controller.allTiersCompleted) ...[
              const SizedBox(height: 8),
              Text(
                'invite_next_reward'.trParams({
                  'count': controller.friendsUntilNextReward.toString(),
                  'days': controller.nextRewardDays.toString(),
                }),
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'invite_all_complete'.tr,
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildRewardCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildRewardCard(
            friends: 1,
            title: 'invite_tier1_title'.tr,
            reward: 'invite_tier1_reward'.tr,
            isReached: controller.tier1Rewarded,
          ),
          const SizedBox(height: 16),
          _buildRewardCard(
            friends: 3,
            title: 'invite_tier2_title'.tr,
            reward: 'invite_tier2_reward'.tr,
            isReached: controller.tier2Rewarded,
          ),
          const SizedBox(height: 16),
          _buildRewardCard(
            friends: 5,
            title: 'invite_tier3_title'.tr,
            reward: 'invite_tier3_reward'.tr,
            isReached: controller.tier3Rewarded,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard({
    required int friends,
    required String title,
    required String reward,
    required RxBool isReached,
  }) {
    return Obx(() {
      final reached = isReached.value;
      
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: reached ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryBlue,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(reached ? 0.3 : 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: reached ? Colors.white : AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  reached ? Icons.check : Icons.group,
                  color: reached ? AppColors.primaryBlue : AppColors.primaryBlue,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: reached ? Colors.white : AppColors.primaryBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward,
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: reached ? Colors.white : AppColors.textDarkNavy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHowItWorks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invite_how_title'.tr,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkNavy,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildStep(
            number: 1,
            text: 'invite_step1'.tr,
          ),
          const SizedBox(height: 20),
          _buildStep(
            number: 2,
            text: 'invite_step2'.tr,
          ),
          const SizedBox(height: 20),
          _buildStep(
            number: 3,
            text: 'invite_step3'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: GoogleFonts.notoSans(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textDarkNavy,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinePrint() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invite_notice_title'.tr,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkNavy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'invite_notice_desc'.tr,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(HapticService hapticService) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: CustomButton(
          text: 'invite_cta'.tr,
          icon: Icons.card_giftcard,
          onPressed: () {
            hapticService.lightImpact();
            controller.shareInvite();
          },
        ),
      ),
    );
  }
}
