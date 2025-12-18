import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 반려동물 프로필 데이터 모델
class PetProfile {
  String? name;
  String? photoPath; // 로컬 파일 경로 또는 Base64
  String? species; // 'dog' or 'cat'
  int? age;
  String? breed;
  
  PetProfile({
    this.name,
    this.photoPath,
    this.species,
    this.age,
    this.breed,
  });
  
  // JSON 변환
  Map<String, dynamic> toJson() => {
    'name': name,
    'photoPath': photoPath,
    'species': species,
    'age': age,
    'breed': breed,
  };
  
  factory PetProfile.fromJson(Map<String, dynamic> json) => PetProfile(
    name: json['name'],
    photoPath: json['photoPath'],
    species: json['species'],
    age: json['age'],
    breed: json['breed'],
  );
  
  // 프로필이 설정되어 있는지 확인
  bool get hasProfile => name != null && name!.isNotEmpty;
  
  // 종류 한글 표시 - localized
  String get speciesKorean => species == 'cat' ? 'species_cat'.tr : 'species_dog'.tr;
  
  // 아이콘 경로
  String get iconPath => species == 'cat' 
      ? 'assets/icons/icon_species_cat.png' 
      : 'assets/icons/icon_species_dog.png';
}

/// 반려동물 프로필 관리 서비스
class PetProfileService extends GetxService {
  static PetProfileService get to => Get.find<PetProfileService>();
  
  final _storage = GetStorage();
  static const String _profileKey = 'pet_profile';
  
  // Observable 프로필
  final Rx<PetProfile> profile = PetProfile().obs;
  
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }
  
  /// 프로필 로드
  void loadProfile() {
    try {
      final jsonStr = _storage.read<String>(_profileKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr);
        profile.value = PetProfile.fromJson(json);
        debugPrint('[PetProfileService] Profile loaded: ${profile.value.name}');
      }
    } catch (e) {
      debugPrint('[PetProfileService] Error loading profile: $e');
    }
  }
  
  /// 프로필 저장
  Future<void> saveProfile(PetProfile newProfile) async {
    try {
      profile.value = newProfile;
      final jsonStr = jsonEncode(newProfile.toJson());
      await _storage.write(_profileKey, jsonStr);
      debugPrint('[PetProfileService] Profile saved: ${newProfile.name}');
    } catch (e) {
      debugPrint('[PetProfileService] Error saving profile: $e');
    }
  }
  
  /// 프로필 초기화
  Future<void> clearProfile() async {
    profile.value = PetProfile();
    await _storage.remove(_profileKey);
  }
  
  /// 개별 필드 업데이트
  Future<void> updateName(String name) async {
    final p = profile.value;
    p.name = name;
    await saveProfile(p);
  }
  
  Future<void> updatePhoto(String photoPath) async {
    final p = profile.value;
    p.photoPath = photoPath;
    await saveProfile(p);
  }
  
  Future<void> updateSpecies(String species) async {
    final p = profile.value;
    p.species = species;
    await saveProfile(p);
  }
  
  Future<void> updateAge(int age) async {
    final p = profile.value;
    p.age = age;
    await saveProfile(p);
  }
  
  Future<void> updateBreed(String breed) async {
    final p = profile.value;
    p.breed = breed;
    await saveProfile(p);
  }
}
