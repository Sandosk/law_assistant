import 'package:flutter/material.dart';
import 'package:investigator/core/spacing.dart';
import 'package:investigator/features/auth/sign_up_screen.dart';
import 'package:investigator/features/home/home_screen.dart';

// ==================== 1. شاشة تسجيل الدخول المحدثة ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkNavy = const Color(0xFF1E255E);

  @override
  Widget build(BuildContext context) {
    // تعريف كائن الـ Spacing لتوليد أبعاد الشاشة الحالية
    final spacing = Spacing(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: spacing.heightSm),
              // الشعار العلوي باستخدام صورة الـ App Icon الممررة
              _buildLogoSection(spacing),
              SizedBox(height: spacing.heightMd),

              // الحاوية البيضاء السفلية المنحنية
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: spacing.screenHeight * 0.04,
                    left: spacing.widthMd,
                    right: spacing.widthMd,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: darkNavy,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: spacing.heightXs),
                        Text(
                          'أدخل بياناتك للمتابعة',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: spacing.heightMd),

                        // حقل رقم الهاتف أو البريد
                        _buildFieldLabel('رقم الهاتف أو البريد الإلكتروني'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: '01xxxxxxxxx',
                          icon: Icons.phone_outlined,
                        ),
                        SizedBox(height: spacing.heightSm),

                        // حقل كلمة المرور
                        _buildFieldLabel('كلمة المرور'),
                        SizedBox(height: spacing.heightXs),
                        _buildTextField(
                          hintText: 'أدخل كلمة المرور',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onSuffixTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        // زر نسيت كلمة المرور
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.heightXs),

                        // زر تسجيل الدخول الرئيسي المتوجه للـ HomeScreen
                        _buildPrimaryButton(
                          text: 'تسجيل الدخول',
                          onPressed: () {
                            // 🎯 الانتقال الفوري لشاشة الـ Home وإغلاق صفحة الدخول لحماية الـ Stack
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: spacing.heightSm),

                        // خط الفصل "أو"
                        _buildDividerOr(),
                        SizedBox(height: spacing.heightSm),

                        // زر إنشاء حساب جديد
                        _buildSecondaryButton(
                          text: 'إنشاء حساب جديد',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: spacing.heightMd),

                        // بنر حماية الخصوصية السفلي المتجاوب
                        _buildPrivacyNotice(),
                        SizedBox(height: spacing.heightSm),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== ميثودز المكونات وشعار الصورة ====================
  Widget _buildLogoSection(Spacing spacing) {
    return Column(
      children: [
        // الحاوية الخارجية المحيطة بالـ Logo المودرن
        Container(
          width: spacing.screenWidth * 0.22, // متجاوب بالكامل مع عرض الشاشة
          height: spacing.screenWidth * 0.22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior:
              Clip.antiAlias, // لقص حواف الصورة لتتناسب مع دائرية الـ Container
          child: Image.asset('assets/images/app_icon.jpg', fit: BoxFit.cover),
        ),
        SizedBox(height: spacing.heightSm),
        const Text(
          'المساعد القانوني الذكي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: spacing.heightXs),
        Text(
          'قانون جنائي مصري • ذكاء اصطناعي',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: darkNavy,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: isPassword
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                )
              : null,
          suffixIcon: Icon(
            icon,
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.6),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D4ED8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF1D4ED8).withValues(alpha: 0.4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: primaryBlue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDividerOr() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'أو',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
      ],
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x0D2563EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1A2563EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              'لا يتم حفظ أي ملفات أو محادثات. تتم جميع عمليات التحليل والمعالجة بشكل مؤقت فقط حفاظاً على خصوصية المستخدم.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.security,
              size: 16, color: primaryBlue.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
