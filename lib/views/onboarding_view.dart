import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/onboarding_service.dart';

// OnboardingView (View in MVC): UI-only, no services
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with TickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF00A651);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color darkGrayText = Color(0xFF1F2937);
  static const Color grayText = Color(0xFF374151);
  static const Color cardBackground = Color(0xFFF9FAFB);
  static const Color cardBorder = Color(0xFFE5E7EB);

  late AnimationController _folderController;
  late AnimationController _mobileController;
  late AnimationController _purpleController;
  late Animation<double> _folderAnimation;
  late Animation<double> _mobileAnimation;
  late Animation<double> _purpleAnimation;

  int visibleCards = 1;

  @override
  void initState() {
    super.initState();
    _folderController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _mobileController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _purpleController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _folderAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _folderController, curve: Curves.easeInOut));
    _mobileAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _mobileController, curve: Curves.easeInOut));
    _purpleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _purpleController, curve: Curves.easeInOut));

    _folderController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _mobileController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _purpleController.forward();
    });
  }

  @override
  void dispose() {
    _folderController.dispose();
    _mobileController.dispose();
    _purpleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cards = [
      {
        'icon': Icons.visibility,
        'iconColor': primaryGreen,
        'title': 'اكتشف',
        'description': 'اعرف الأذونات الخفية لكل تطبيقاتك',
      },
      {
        'icon': Icons.settings,
        'iconColor': Colors.blue,
        'title': 'تحكم',
        'description': 'تساعدك على إدارة الأذونات الخطيرة بسهولة',
      },
      {
        'icon': Icons.lock,
        'iconColor': Colors.orange,
        'title': 'خصوصيتك أولاً',
        'description': 'كل التحليلات تتم على جهازك لحماية بياناتك',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, lightGreen],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: primaryGreen.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryGreen, width: 2),
                            ),
                            child: const Icon(
                              Icons.security,
                              color: primaryGreen,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'أهلاً بك في حارس الخصوصية',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: darkGrayText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: 300,
                            height: 260,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 50,
                                  top: 20,
                                  child: Container(
                                    width: 200,
                                    height: 220,
                                    decoration: const BoxDecoration(
                                      color: primaryGreen,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        topRight: Radius.circular(100),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.security,
                                          color: primaryGreen,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _buildAnimatedIcon(
                                  animation: _folderAnimation,
                                  color: Colors.orange,
                                  icon: Icons.folder,
                                  left: 20,
                                  top: 60,
                                ),
                                _buildAnimatedIcon(
                                  animation: _mobileAnimation,
                                  color: Colors.blue,
                                  icon: Icons.phone_android,
                                  right: 20,
                                  top: 30,
                                ),
                                _buildAnimatedIcon(
                                  animation: _purpleAnimation,
                                  color: Colors.purple,
                                  icon: Icons.apps,
                                  right: 40,
                                  bottom: 20,
                                  isCircle: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (int i = 0; i < visibleCards; i++) ...[
                              AnimatedOpacity(
                                opacity: 1,
                                duration: const Duration(milliseconds: 500),
                                child: _buildFeatureCard(
                                  icon: cards[i]['icon'],
                                  iconColor: cards[i]['iconColor'],
                                  title: cards[i]['title'],
                                  description: cards[i]['description'],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ],
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (visibleCards < cards.length) {
                          setState(() {
                            visibleCards++;
                          });
                          return;
                        }
                        // Mark general onboarding as completed and navigate to iOS privacy onboarding
                        if (!mounted) return;
                        await OnboardingService.setOnboardingCompleted();
                        Navigator.of(context).pushNamed('/ios-privacy');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: primaryGreen.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        visibleCards == cards.length ? 'ابدأ الآن' : 'تابع',
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

  Widget _buildAnimatedIcon({
    required Animation<double> animation,
    required Color color,
    required IconData icon,
    double? left,
    double? right,
    double? top,
    double? bottom,
    bool isCircle = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          left: left != null ? left + (animation.value * 10) : null,
          right: right != null ? right + (animation.value * 10) : null,
          top: top != null ? top + (sin(animation.value * 3.14) * 5) : null,
          bottom: bottom != null ? bottom + (sin(animation.value * 3.14) * 5) : null,
          child: Transform.scale(
            scale: 0.8 + (animation.value * 0.2),
            child: Container(
              width: isCircle ? 40 : 50,
              height: isCircle ? 40 : 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: isCircle ? null : BorderRadius.circular(12),
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: isCircle ? 20 : 24),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGrayText,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: grayText,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
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


