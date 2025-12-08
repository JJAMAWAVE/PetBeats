import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthService extends GetxService {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initFirebase();
  }
  
  Future<void> _initFirebase() async {
    // Delay Firebase initialization to avoid blocking app startup
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
      
      if (_auth != null) {
        // Safe stream binding
        _auth!.authStateChanges().listen(
          (user) => currentUser.value = user,
          onError: (e) => debugPrint('AuthService: Stream error: $e'),
        );
        isInitialized.value = true;
        debugPrint('AuthService: Firebase initialized successfully');
      }
    } catch (e) {
      debugPrint('AuthService: Firebase not initialized or error: $e');
      // App continues without Firebase - graceful fallback
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (_auth == null || _googleSignIn == null) {
      debugPrint('AuthService: Firebase not initialized');
      Get.snackbar('로그인 불가', 'Firebase가 초기화되지 않았습니다.');
      return null;
    }
    
    try {
      isLoading.value = true;
      
      // 1. Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return null; // User canceled
      }

      // 2. Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final UserCredential userCredential = await _auth!.signInWithCredential(credential);
      
      isLoading.value = false;
      return userCredential;
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error signing in with Google: $e');
      Get.snackbar(
        '로그인 실패', 
        '구글 로그인을 사용할 수 없습니다. 나중에 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (_googleSignIn != null) await _googleSignIn!.signOut();
      if (_auth != null) await _auth!.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
  
  // Simulation for testing without valid config
  Future<void> simulateLogin() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    // We can't really "fake" a Firebase User easily without a wrapper,
    // but we can set a local state if we abstracted the User model.
    // For now, we just show success message.
    Get.snackbar('테스트 모드', '가상 로그인 성공 (기능 테스트용)');
    isLoading.value = false;
  }
}
