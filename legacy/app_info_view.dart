import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppInfoView extends StatefulWidget {
  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<AppInfoView> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation Controllers
  late AnimationController _tapTextController;
  late AnimationController _entranceController;
  late AnimationController _breathingController;
  late AnimationController _heartbeatController;
  late AnimationController _pulseController;
  late AnimationController _slowZoomController; // Added for Page 4

  final List<Map<String, dynamic>> _pages = [
    {
      'image': 'assets/images/AppInfo/page_2.png',
      'title': '과학으로 설계된\n소리 치료.',
      'subtitle': '뇌파를 안정시키는 주파수와 햅틱 진동으로,\n불안했던 아이가 깊은 잠에 빠져듭니다.',
      'badges': [
        {'icon': '🐶', 'text': 'Dog: Anxiety Relief'},
        {'icon': '🐱', 'text': 'Cat: Stress Reduction'},
      ],
    },
    {
      'image': 'assets/images/AppInfo/page_3.png',
      'title': '우리 아이의 소음 민감도는\n\'매우 높음\'입니다.',
      'subtitle': '도시 환경의 복잡한 소리 자극이 아이에게\n지속적인 스트레스를 주고 있습니다.\n맞춤형 케어가 필요합니다.',
    },
    {
      'image': 'assets/images/AppInfo/page_4.png',
      'title': '우리에겐 침묵이지만,\n아이에겐 소음입니다.',
      'subtitle': '사람은 20kHz까지만 듣지만,\n강아지는 45kHz, 고양이는 64kHz의\n초고역대 소음까지 듣습니다.\n냉장고 모터 소리조차 그들에겐 고통일 수 있습니다.',
      'footer': 'Source: Louisiana State University, School of Veterinary Medicine',
    },
    {
      'image': 'assets/images/AppInfo/page_5.png',
      'title': '심장과 뇌파를\n동기화합니다.',
      'subtitle': '🐶 [Dog Mode]: 대형견의 휴식 심박수인 60 BPM 리듬은 본능적인 안정과 수면을 유도합니다.\n\n🐱 [Cat Mode]: 20~50Hz 대역의 골골송(Purring) 주파수는 고양이의 긴장 완화와 치유를 돕습니다.',
      'footer': 'Source: Bioacoustics Research / JASA',
    },
    {
      'image': 'assets/images/AppInfo/page_6.png',
      'title': '당신의 아이만\n예민한 것이 아닙니다.',
      'subtitle': '연구에 따르면 반려견의 72.5%가 소음 민감증과 불안을 겪고 있으며, 반려묘의 64% 또한 환경적 스트레스를 보입니다.\n이제 PetBeats로 평화를 선물하세요.',
      'footer': 'Source: Salonen et al., Scientific Reports (2020, 2021)',
    },
    {
      'image': 'assets/images/AppInfo/page_1.png',
      'title': '아이를 위한\n테라피 프로필을 저장하세요.',
      'subtitle': '기기를 변경해도 우리 아이 맞춤 설정이 그대로 유지됩니다.\n공기계와 연동하여 언제든 편하게 케어하세요.',
      'hasAction': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Tap Text Breathing (Loop)
    _tapTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Entrance Animation (One-shot)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Breathing Image (Loop)
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Heartbeat (Loop)
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Pulse (Loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Slow Zoom (Loop) - Added
    _slowZoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tapTextController.dispose();
    _entranceController.dispose();
    _breathingController.dispose();
    _heartbeatController.dispose();
    _pulseController.dispose();
    _slowZoomController.dispose(); // Added
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _entranceController.reset();
    _entranceController.forward();
  }

  void _handleLogin() {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.white)),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loading dialog
      Get.back(); // Close AppInfoView
      Get.snackbar(
        '알림',
        '계정이 연동되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textDarkNavy,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], index);
            },
          ),

          // Close Button
          Positioned(
            top: 48,
            right: 24,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black87, size: 24),
              ),
            ),
          ),

          // Page Indicators (Moved up)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primaryBlue : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Tap to Start Text (Bottom)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _tapTextController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.2 + (_tapTextController.value * 0.8),
                  child: Text(
                    AppLocalizations.of(context)?.tapToStart ?? '화면을 터치하여 시작',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> data, int index) {
    // Define animations based on index
    Widget imageWidget = Image.asset(
      data['image'],
      fit: BoxFit.cover,
    );

    // Page 0 (Scientific): Entrance Scale
    if (index == 0) {
      imageWidget = ScaleTransition(
        scale: CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOutBack,
        ),
        child: imageWidget,
      );
    }
    // Page 1 (Sensitivity): Breathing Image
    else if (index == 1) {
      imageWidget = AnimatedBuilder(
        animation: _breathingController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_breathingController.value * 0.05),
            child: child,
          );
        },
        child: imageWidget,
      );
    }
    // Page 3 (Heartbeat): Heartbeat Image
    else if (index == 3) {
      imageWidget = AnimatedBuilder(
        animation: _heartbeatController,
        builder: (context, child) {
          final val = _heartbeatController.value;
          // Simple heartbeat curve simulation
          final scale = 1.0 + (val < 0.2 ? val * 0.2 : (val < 0.4 ? (0.4 - val) * 0.2 : 0.0));
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: imageWidget,
      );
    }
    // Page 4 (Stats): Slow Zoom
    else if (index == 4) {
      imageWidget = AnimatedBuilder(
        animation: _slowZoomController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_slowZoomController.value * 0.05), // Subtle zoom
            child: child,
          );
        },
        child: imageWidget,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 80, bottom: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: imageWidget,
                ),
              ),
            ),
          ),

          // Text Area
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Animation (Slide Up)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _entranceController,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  )),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                    ),
                    child: Text(
                      data['title'],
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textDarkNavy,
                        fontSize: 28,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Subtitle Animation (Slide In from Right for Page 2, else Fade Up)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: index == 2 ? const Offset(0.2, 0) : const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _entranceController,
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                  )),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                    ),
                    child: Text(
                      data['subtitle'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDarkNavy.withOpacity(0.7),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                
                if (data['badges'] != null) ...[
                  const SizedBox(height: 24),
                  // Badges Animation (Scale/Fade)
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
                    ),
                    child: Row(
                      children: (data['badges'] as List).map<Widget>((badge) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Text(badge['icon'], style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                badge['text'],
                                style: const TextStyle(
                                  color: AppColors.primaryBlue, 
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                if (data['hasAction'] == true) ...[
                  const Spacer(),
                  // Login Button Animation (Pulse)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.03),
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textDarkNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Google/Apple로 계속하기',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120), // Extra space for bottom text
                ],

                if (data['footer'] != null) ...[
                  const Spacer(),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                    ),
                    child: Text(
                      data['footer'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120), // Space for indicators and bottom text
                ] else if (data['hasAction'] != true) ...[
                   const SizedBox(height: 120),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
