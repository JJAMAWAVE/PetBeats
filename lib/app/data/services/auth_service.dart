import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Firebase initialization should be done in main.dart, 
    // but we listen to changes here if initialized.
    try {
      currentUser.bindStream(_auth.authStateChanges());
      isInitialized.value = true;
    } catch (e) {
      debugPrint('AuthService: Firebase not initialized or error: $e');
      // Fallback for development without google-services.json
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // 1. Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
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
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      isLoading.value = false;
      return userCredential;
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error signing in with Google: $e');
      Get.snackbar('로그인 실패', '구글 로그인 중 오류가 발생했습니다: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
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
