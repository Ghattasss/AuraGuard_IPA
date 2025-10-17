import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _iosPrivacyOnboardingCompletedKey = 'ios_privacy_onboarding_completed';

  // Check if general onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // Mark general onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  // Check if iOS privacy onboarding is completed
  static Future<bool> isIosPrivacyOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_iosPrivacyOnboardingCompletedKey) ?? false;
  }

  // Mark iOS privacy onboarding as completed
  static Future<void> setIosPrivacyOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_iosPrivacyOnboardingCompletedKey, true);
  }

  // Check if user is first time (needs any onboarding)
  static Future<bool> isFirstTimeUser() async {
    final generalCompleted = await isOnboardingCompleted();
    final iosPrivacyCompleted = await isIosPrivacyOnboardingCompleted();
    return !generalCompleted || !iosPrivacyCompleted;
  }

  // Reset onboarding state (useful for testing or if user wants to see onboarding again)
  static Future<void> resetOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
    await prefs.remove(_iosPrivacyOnboardingCompletedKey);
  }

  // Get the next route based on onboarding status
  static Future<String> getNextRoute() async {
    final generalCompleted = await isOnboardingCompleted();
    final iosPrivacyCompleted = await isIosPrivacyOnboardingCompleted();

    if (!generalCompleted) {
      return '/onboarding';
    } else if (!iosPrivacyCompleted) {
      return '/ios-privacy';
    } else {
      return '/home';
    }
  }
}
