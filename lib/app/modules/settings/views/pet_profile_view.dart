import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../data/services/pet_profile_service.dart';

class PetProfileView extends StatefulWidget {
  const PetProfileView({super.key});

  @override
  State<PetProfileView> createState() => _PetProfileViewState();
}

class _PetProfileViewState extends State<PetProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _breedController = TextEditingController();
  
  String _selectedSpecies = 'dog';
  String? _photoBase64;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }
  
  void _loadCurrentProfile() {
    try {
      final profileService = Get.find<PetProfileService>();
      final profile = profileService.profile.value;
      
      _nameController.text = profile.name ?? '';
      _ageController.text = profile.age?.toString() ?? '';
      _breedController.text = profile.breed ?? '';
      _selectedSpecies = profile.species ?? 'dog';
      
      // Base64 사진 로드
      if (profile.photoPath != null && profile.photoPath!.startsWith('data:')) {
        _photoBase64 = profile.photoPath;
      }
      
      setState(() {});
    } catch (e) {
      debugPrint('[PetProfileView] Error loading profile: $e');
    }
  }
  
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        // Base64로 변환하여 저장
        final bytes = await image.readAsBytes();
        final base64 = base64Encode(bytes);
        setState(() {
          _photoBase64 = 'data:image/jpeg;base64,$base64';
        });
      }
    } catch (e) {
      debugPrint('[PetProfileView] Error picking image: $e');
      Get.snackbar(
        '알림', 
        '이미지를 선택할 수 없습니다',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
    }
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final profileService = Get.find<PetProfileService>();
      
      final newProfile = PetProfile(
        name: _nameController.text.trim(),
        photoPath: _photoBase64,
        species: _selectedSpecies,
        age: int.tryParse(_ageController.text) ?? 0,
        breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
      );
      
      await profileService.saveProfile(newProfile);
      
      Get.snackbar(
        '저장 완료',
        '${newProfile.name}의 프로필이 저장되었습니다!',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
      
      Get.back();
    } catch (e) {
      debugPrint('[PetProfileView] Error saving profile: $e');
      Get.snackbar('오류', '프로필 저장에 실패했습니다');
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('반려동물 프로필'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDarkNavy),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              '저장',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 프로필 사진
              _buildPhotoSection(),
              
              SizedBox(height: 32.h),
              
              // 이름
              _buildTextField(
                controller: _nameController,
                label: '이름',
                hint: '반려동물 이름을 입력하세요',
                icon: Icons.pets,
                required: true,
              ),
              
              SizedBox(height: 16.h),
              
              // 종류 선택
              _buildSpeciesSelector(),
              
              SizedBox(height: 16.h),
              
              // 나이
              _buildTextField(
                controller: _ageController,
                label: '나이',
                hint: '나이를 입력하세요',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
                suffix: '살',
                required: true,
              ),
              
              SizedBox(height: 16.h),
              
              // 품종 (선택)
              _buildTextField(
                controller: _breedController,
                label: '품종 (선택)',
                hint: '예: 골든 리트리버, 페르시안',
                icon: Icons.category,
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPhotoSection() {
    Widget photoWidget;
    
    if (_photoBase64 != null) {
      // Base64 이미지
      final base64Data = _photoBase64!.split(',').last;
      photoWidget = Image.memory(
        base64Decode(base64Data),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultIcon(),
      );
    } else {
      photoWidget = _buildDefaultIcon();
    }
    
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: photoWidget,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 20.w),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefaultIcon() {
    return Image.asset(
      _selectedSpecies == 'cat'
          ? 'assets/icons/icon_species_cat.png'
          : 'assets/icons/icon_species_dog.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(
        Icons.pets,
        size: 60.w,
        color: AppColors.primaryBlue.withOpacity(0.5),
      ),
    );
  }
  
  Widget _buildSpeciesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            '종류',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildSpeciesOption(
                species: 'dog',
                label: '강아지',
                icon: 'assets/icons/icon_species_dog.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSpeciesOption(
                species: 'cat',
                label: '고양이',
                icon: 'assets/icons/icon_species_cat.png',
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSpeciesOption({
    required String species,
    required String label,
    required String icon,
  }) {
    final isSelected = _selectedSpecies == species;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedSpecies = species),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 32.w,
              height: 32.w,
              errorBuilder: (_, __, ___) => Icon(
                Icons.pets,
                size: 32.w,
                color: isSelected ? AppColors.primaryBlue : Colors.grey,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: required
              ? (value) => value?.trim().isEmpty == true ? '필수 항목입니다' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            suffixText: suffix,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
