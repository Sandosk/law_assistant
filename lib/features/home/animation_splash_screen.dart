import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:investigator/features/auth/login_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // حركات الشعار والنصوص
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // حركة الموجات (تأثير مستمر)
  late Animation<double> _waveProgressAnimation;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    // إعداد الـ Controller الرئيسي (تم ضبط المدة الإجمالية لتكون كافية لعرض الأمواج)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500), // 4.5 ثوانٍ لوقت كافٍ ومريح
    );

    // 1. حركة ظهور الشعار (Fade In) خلال أول 30% من الوقت
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 2. حركة خروج الشعار من الأسفل (Slide Up) بارتداد جمالي مميز
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5), // يبدأ من الأسفل
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // 3. حركة الأمواج الدائرية المستمرة (تأخذ كامل الوقت المتبقي لتعرض تدفقاً متكرراً)
    _waveProgressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.linear),
      ),
    );

    // بدء الحركات
    _animationController.forward();

    // الانتقال التلقائي والآمن لشاشة الـ Login فور انتهاء الـ 4.5 ثوانٍ
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    // ننتظر 4.5 ثانية بالكامل ليعرض كافة الأمواج
    await Future.delayed(const Duration(milliseconds: 4500));

    if (mounted) {
      // الانتقال الفعلي إلى الـ LoginScreen مع إزالتها من الـ Stack لمنع المستخدم من الرجوع للخلف
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF1E255E)
            ], // ألوان الهوية القضائية الجنائية الفخمة
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // خلفية الأمواج التفاعلية (Ripple Waves) التي تنبثق بشكل مكرر ومستمر خلف الشعار
            AnimatedBuilder(
              animation: _waveProgressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RippleWavesPainter(
                    progress: _waveProgressAnimation.value,
                  ),
                  child: const SizedBox(
                    width: 400, // زيادة الأبعاد لتغطية مساحة أكبر من الشاشة
                    height: 400,
                  ),
                );
              },
            ),

            // كتل الشعار والنصوص التوعوية في المنتصف
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // دمج حركتي الـ Slide والـ Fade للشعار
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/app_icon.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // النصوص المرافقة تظهر بالتزامن مع استقرار الشعار
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'المساعد القانوني الذكي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'قانون جنائي مصري • ذكاء اصطناعي',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// رسام الأمواج الدائرية الاحترافي (Ripple Waves Painter)
// =========================================================================
class RippleWavesPainter extends CustomPainter {
  final double progress;

  RippleWavesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 1.1; // أبعاد موسعة لتكون الأمواج ضخمة وواضحة

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // بث 4 موجات دائرية متتالية ومتباعدة بشكل رياضي متوازن لتعطي انطباع التدفق
    for (int i = 0; i < 4; i++) {
      // إزاحة زمنية دقيقة لكل موجة لتخرج الواحدة تلو الأخرى بشكل متكرر ومستمر
      double waveProgress = progress - (i * 0.25);
      if (waveProgress < 0) waveProgress += 1.0;
      if (waveProgress > 1.0) waveProgress -= 1.0;

      final radius = maxRadius * waveProgress;
      // تتلاشى الشفافية تدريجياً كلما اقتربت الموجة من الحواف الخارجية
      final opacity = (1.0 - waveProgress).clamp(0.0, 1.0) * 0.22;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RippleWavesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
