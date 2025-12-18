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

  List<Map<String, dynamic>> get _pages => [
    {
      'image': 'assets/images/AppInfo/page_2.png',
      'title': 'app_info_p1_title'.tr,
      'subtitle': 'app_info_p1_subtitle'.tr,
      'badges': [
        {'icon': '🐶', 'text': 'app_info_p1_badge1'.tr},
        {'icon': '🐱', 'text': 'app_info_p1_badge2'.tr},
      ],
    },
    {
      'image': 'assets/images/AppInfo/page_3.png',
      'title': 'app_info_p2_title'.tr,
      'subtitle': 'app_info_p2_subtitle'.tr,
    },
    {
      'image': 'assets/images/AppInfo/page_4.png',
      'title': 'app_info_p3_title'.tr,
      'subtitle': 'app_info_p3_subtitle'.tr,
      'footer': 'Source: Louisiana State University, School of Veterinary Medicine',
    },
    {
      'image': 'assets/images/AppInfo/page_5.png',
      'title': 'app_info_p4_title'.tr,
      'subtitle': 'app_info_p4_subtitle'.tr,
      'footer': 'Source: Bioacoustics Research / JASA',
    },
    {
      'image': 'assets/images/AppInfo/page_6.png',
      'title': 'app_info_p5_title'.tr,
      'subtitle': 'app_info_p5_subtitle'.tr,
      'footer': 'Source: Salonen et al., Scientific Reports (2020, 2021)',
    },
    {
      'image': 'assets/images/AppInfo/page_1.png',
      'title': 'app_info_p6_title'.tr,
      'subtitle': 'app_info_p6_subtitle'.tr,
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
        'notice'.tr,
        'account_linked'.tr,
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
          // Page View with Card Stack Effect
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: List.generate(_pages.length, (index) {
                  // Calculate offset from current page
                  final offset = index - _currentPage;
                  
                  // Only render current and next 2 cards
                  if (offset < 0 || offset > 2) {
                    return const SizedBox.shrink();
                  }
                  
                  // Scale and position for stacked effect
                  final scale = 1.0 - (offset * 0.05);
                  final translateY = offset * 12.0;
                  final opacity = offset == 0 ? 1.0 : 0.6 - (offset * 0.15);
                  
                  return Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.topCenter,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 1.0),
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! < 0 && _currentPage < _pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                );
                              } else if (details.primaryVelocity! > 0 && _currentPage > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                );
                              }
                            },
                            child: _buildPage(_pages[index], index),
                          ),
                        ),
                      ),
                    ),
                  );
                }).reversed.toList(),
              );
            },
          ),
          
          // Invisible PageView for controller sync
          Opacity(
            opacity: 0,
            child: IgnorePointer(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (_, __) => const SizedBox(),
              ),
            ),
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

          Positioned(
            bottom: 70,
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
            bottom: 24,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _tapTextController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.2 + (_tapTextController.value * 0.8),
                  child: Text(
                    AppLocalizations.of(context)?.tapToStart ?? 'tap_to_start'.tr,
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
          // Image Area - 4:5 비율로 조정하여 텍스트 공간 확보
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 60, bottom: 20),
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

          // Text Area - 5:4 비율로 확대
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100), // 하단 indicator/텍스트 공간 확보
              child: SingleChildScrollView(
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
                          fontSize: 24,
                          height: 1.25,
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
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  if (data['badges'] != null) ...[
                    const SizedBox(height: 24),
                    // Badges Animation (Scale/Fade) - Wrap으로 오버플로우 방지
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _entranceController,
                        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
                      ),
                      child: Wrap(
                        spacing: 8,  // 가로 간격
                        runSpacing: 8, // 세로 간격 (줄바꿈 시)
                        children: (data['badges'] as List).map<Widget>((badge) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,  // 콘텐츠 크기에 맞춤
                              children: [
                                Text(badge['icon'], style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(
                                  badge['text'],
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue, 
                                    fontSize: 11,  // 폰트 크기 축소
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
                    const SizedBox(height: 24),
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
                          child: Text(
                            'app_info_continue_action'.tr,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120), // Extra space for bottom text
                  ],

                  if (data['footer'] != null) ...[
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entranceController,
                        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                      ),
                      child: Text(
                        data['footer'],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else if (data['hasAction'] != true) ...[
                     const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
