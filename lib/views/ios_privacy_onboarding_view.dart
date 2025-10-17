import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/onboarding_service.dart';

// iOS Privacy Onboarding View - Second onboarding screen
class IosPrivacyOnboardingView extends StatelessWidget {
  const IosPrivacyOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Header with back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: const Color(0xFF00A651),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),

                // Main content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'أهلاً بك في حارس الخصوصية',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Illustration card
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF00A651).withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Settings icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFF00A651),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.settings,
                                  color: Color(0xFF00A651),
                                  size: 40,
                                ),
                              ),
                              // Lock icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFF00A651),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF00A651),
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Description text
                      Text(
                        'بسبب تصميم نظام iOS الذي يركز على الخصوصية. لا يمكننا فحص تطبيقاتك الأخرى تلقائياً. وهذا شيء جيد!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: const Color(0xFF374151),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'مهمتنا هي أن تكون دليلك الخبير لتتحكم في خصوصيتك بنفسك.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: const Color(0xFF374151),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Mark iOS privacy onboarding as completed and navigate to home screen
                        await OnboardingService.setIosPrivacyOnboardingCompleted();
                        if (!context.mounted) return;
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFF00A651).withValues(alpha: 0.4),
                      ),
                      child: Text(
                        'لنبدأ رحلة الخصوصية',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
